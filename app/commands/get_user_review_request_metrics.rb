class GetUserReviewRequestMetrics < PowerTypes::Command.new(:github_user, :limit_month)
  def perform
    @entry_count = 0
    @total_time = 0
    @review_requests_dic = Hash.new
    @review_requests_dic["pull_requests_information"] = Hash.new
    get_valid_pull_requests.each do |pr|
      add_pr_data_to_hash(pr)
    end
    @review_requests_dic["personal_mean"] = @entry_count.positive? ? @total_time / @entry_count : 0
    @review_requests_dic
  end

  def pr_has_review_requests(pull_request)
    monkey = GithubUser.find_by(login: "monkeyci")
    review_requests = pull_request.pull_request_review_requests
                                  .where.not(github_user_id: monkey.id)
                                  .order(created_at: :asc)
    review_requests.first
  end

  def get_valid_pull_requests
    limit_date = (Time.zone.today - @limit_month.to_i.months).beginning_of_day
    @github_user.pull_requests.where('gh_created_at > ?', limit_date).where.not(merged_by_id: nil)
  end

  def get_pr_info(pull_request, review_req, time_delta)
    { pr_title: pull_request.title, pr_created_at: pull_request.gh_created_at.to_s,
      review_request_created_at: review_req.created_at.to_s,
      time_delta: time_delta }
  end

  def add_pr_data_to_hash(pull_request)
    if review_req = pr_has_review_requests(pull_request)
      time_delta = (review_req.created_at - pull_request.gh_created_at).to_i
      unless time_delta > 1.week
        @entry_count += 1
        @total_time += time_delta
        @review_requests_dic["pull_requests_information"][pull_request.id] = get_pr_info(
          pull_request, review_req, time_delta
        )
      end
    end
  end
end
