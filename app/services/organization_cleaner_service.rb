class OrganizationCleanerService < PowerTypes::Service.new(:token)
  def clean(organization)
    ex_memb_ids = ex_members_gh_ids(organization)
    prs_ids = prs_ids_to_delete(ex_memb_ids)
    delete_prs_relations(prs_ids)
    delete_prs_reviews(prs_ids)
    delete_prs(prs_ids)
    delete_ex_members(organization, ex_memb_ids)
  end

  def prs_ids_to_delete(mem_ids)
    PullRequestRelation.where(github_user_id: mem_ids)
                       .or(PullRequestRelation.where(target_user_id: mem_ids))
                       .pluck(:pull_request_id)
  end

  def delete_prs_relations(prs_ids_delete)
    PullRequestRelation.where(pull_request_id: prs_ids_delete).destroy_all
  end

  private

  def ex_members_gh_ids(organization)
    GithubOrgMembershipService.new(token: @token).ex_members_ids(organization)
  end

  def delete_prs_reviews(prs_ids_delete)
    GithubPullRequestReviewService.new(token: @token).delete_prs_reviews(prs_ids_delete)
  end

  def delete_prs(prs_ids_delete)
    GithubPullRequestService.new(token: @token).delete_prs(prs_ids_delete)
  end

  def delete_ex_members(organization, ex_memb_ids)
    GithubOrgMembershipService.new(token: @token)
                              .delete_ex_members(organization, ex_memb_ids)
  end
end
