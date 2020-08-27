class GetUserPullRequestMetrics < PowerTypes::Command.new(:github_user, :limit_month)
  MONTH_LIMIT_DEFAULT = 9

  def perform
    @review_requests_dic = Hash.new
    @review_requests_dic[:pull_requests_information] = Hash.new
    get_valid_pull_requests.each do |pr|
      add_pr_data_to_hash(pr)
    end
    @review_requests_dic
  end

  def limit_month
    @limit_month ||= MONTH_LIMIT_DEFAULT
  end

  def pr_has_review_requests(pull_request)
    monkey = GithubUser.find_by(login: "monkeyci")
    review_requests = pull_request.pull_request_review_requests
                                  .where.not(github_user_id: monkey.id)
                                  .order(created_at: :asc)
    review_requests.first
  end

  def get_valid_pull_requests
    limit_date = (Time.zone.today - limit_month.to_i.months).beginning_of_day
    @github_user.pull_requests.where('gh_created_at > ?', limit_date).where.not(merged_by_id: nil)
  end

  def get_basic_pull_request_info(pull_request, review_request)
    { pr_title: pull_request.title, pr_created_at: pull_request.gh_created_at.to_s,
      pr_merget_at: pull_request.gh_merged_at.to_s,
      review_request_created_at: review_request.created_at.to_s }
  end

  def add_pr_data_to_hash(pull_request)
    if review_request = pr_has_review_requests(pull_request)
      time_delta = (review_request.created_at - pull_request.gh_created_at).to_i
      unless time_delta > 1.week
        current_pull_request_info = get_basic_pull_request_info(pull_request, review_request)
        current_pull_request_info.merge!(GetPullRequestReviewsInfo.for(pull_request: pull_request))
        pr_id = pull_request.id
        @review_requests_dic[:pull_requests_information][pr_id] = current_pull_request_info
      end
    end
  end
end
