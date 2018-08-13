class CorrelationMatrix
  attr_accessor :tracked_users, :data, :pos_hash

  def initialize(org_id, user_ids)
    @organization = Organization.find(org_id)
    @pr_relations = PullRequestRelation.by_organizations(org_id).within_month_limit
    @tracked_users = @organization.tracked_members
    @tracked_users = @tracked_users.where(gh_id: user_ids) if user_ids
    @pos_hash = Hash[@tracked_users.map(&:id).map.with_index { |x, i| [x, i] }]
    @data = Hash.new(0)
  end

  def fill_matrix
    @tracked_users.each_with_index do |user, index|
      gh_user_interactions(user).each do |key, value|
        @data[[index, @pos_hash[key]]] += value
      end
      @data[[index, index]] = user_alone_prs(user)
    end
  end

  private

  def gh_user_interactions(gh_user)
    @pr_relations.where(target_user_id: gh_user.id)
                 .where(github_user_id: @tracked_users.pluck(:id))
                 .where.not(github_user_id: gh_user.id)
                 .group(:github_user_id).count
  end

  def user_alone_prs(user)
    merged_pr_ids = gh_user_merged_pull_req_ids(user)
    coop_pr_ids = gh_user_coop_pull_req_ids(user, merged_pr_ids)
    merged_pr_ids.length - coop_pr_ids.length
  end

  # Get user pull requests where had been merged by himself
  def gh_user_merged_pull_req_ids(gh_user)
    @pr_relations.where(target_user_id: gh_user.id,
                        pr_relation_type: :merged_by,
                        github_user_id: gh_user.id)
                 .group(:pull_request_id)
                 .pluck(:pull_request_id)
  end

  # Get pull requests where others users had reviewed
  # Params:
  # +pr_ids+ pull request ids to filter
  def gh_user_coop_pull_req_ids(gh_user, pr_ids)
    @pr_relations.where(pull_request_id: pr_ids, pr_relation_type: :reviewer)
                 .where.not(github_user_id: gh_user.id)
                 .group(:pull_request_id)
                 .pluck(:pull_request_id)
  end
end
