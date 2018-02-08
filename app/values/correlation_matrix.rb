class CorrelationMatrix
  attr_accessor :tracked_users, :data, :pos_hash

  def initialize(org_id)
    @organization = Organization.find(org_id)
    @tracked_users = participants
    @pos_hash = Hash[@tracked_users.map(&:id).map.with_index { |x, i| [x, i] }]
    @data = Hash.new(0)
  end

  def fill_matrix
    @tracked_users.each_with_index do |user, index|
      gh_user_interactions(user, @organization.id).each do |key, value|
        @data[[index, @pos_hash[key]]] += value
      end
      @data[[index, index]] = user_alone_prs(user)
    end
  end

  private

  def participants
    GithubUser
      .joins(pull_request_relations: { pull_request: :repository })
      .where(pull_request_relations: {
               pull_requests: { repositories: { organization_id: @organization.id } }
             })
      .group(:id)
  end

  def gh_user_interactions(gh_user, orga_ids = nil)
    PullRequestRelation.within_month_limit
                       .by_organizations(orga_ids)
                       .where(pull_requests: { owner_id: gh_user.id })
                       .where(github_user_id: @tracked_users.pluck(:id))
                       .where.not(github_user_id: gh_user.id)
                       .group(:github_user_id).count
  end

  def user_alone_prs(user)
    merged_pr_ids = gh_user_merged_pull_requests(user, @organization.id).pluck(:id)
    coop_pr_ids = gh_user_coop_pull_requests(user, merged_pr_ids, @organization.id).pluck(:id)
    (merged_pr_ids - coop_pr_ids).length
  end

  # Get user pull requests where had been merged by himself
  def gh_user_merged_pull_requests(gh_user, orga_ids = nil)
    gh_user.pull_requests.within_month_limit
           .by_organizations(orga_ids)
           .joins(:pull_request_relations)
           .where(pull_request_relations: { pr_relation_type: :merged_by,
                                            github_user_id: gh_user.id })
           .group(:id)
  end

  # Get pull requests where others users had reviewed
  # Params:
  # +pr_ids+ pull request ids to filter
  def gh_user_coop_pull_requests(gh_user, pr_ids, orga_ids = nil)
    gh_user.pull_requests.within_month_limit
           .by_organizations(orga_ids)
           .joins(:pull_request_relations)
           .where(id: pr_ids, pull_request_relations: { pr_relation_type: :reviewer })
           .where.not(pull_request_relations: { github_user_id: gh_user.id })
           .group(:id)
  end
end
