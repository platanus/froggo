class ComputeGithubContributions <
  PowerTypes::Command.new(:user_id, :other_users_ids, :pr_relations)
  def perform
    {
      self_reviewed_prs: self_reviewed_prs,
      per_user_contributions: per_user_contributions
    }
  end

  private

  def self_reviewed_prs
    merged_pr_ids = gh_user_merged_pull_req_ids
    coop_pr_ids = gh_user_coop_pull_req_ids(merged_pr_ids)
    merged_pr_ids.length - coop_pr_ids.length
  end

  def per_user_contributions
    map_other_user_id_to_index = Hash[
      @other_users_ids.map.with_index do |id, index|
        [id, index]
      end
    ]
    result = Array.new(@other_users_ids.length, 0)
    gh_user_interactions.each do |other_user_id, contributions_for_user|
      result[
        map_other_user_id_to_index[other_user_id]
      ] = contributions_for_user
    end
    result
  end

  def gh_user_interactions
    @pr_relations.where(target_user_id: @user_id)
                 .where(github_user_id: [@user_id, *@other_users_ids])
                 .where.not(github_user_id: @user_id)
                 .group(:github_user_id).count
  end

  # Get user pull requests that had been merged by himself.
  def gh_user_merged_pull_req_ids
    @pr_relations.where(target_user_id: @user_id,
                        pr_relation_type: :merged_by,
                        github_user_id: @user_id)
                 .group(:pull_request_id)
                 .pluck(:pull_request_id)
  end

  # Get pull requests where others users are reviewers.
  # Params:
  # +pr_ids+ pull request ids to filter
  def gh_user_coop_pull_req_ids(pr_ids)
    @pr_relations.where(pull_request_id: pr_ids, pr_relation_type: :reviewer)
                 .where.not(github_user_id: @user_id)
                 .group(:pull_request_id)
                 .pluck(:pull_request_id)
  end
end
