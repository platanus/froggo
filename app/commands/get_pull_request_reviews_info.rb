class GetPullRequestReviewsInfo < PowerTypes::Command.new(:pull_request)
  def perform
    @reviews = get_human_reviews
    reviews_info = Hash.new
    reviews_info[:first_response] = first_responder.created_at.to_s if first_responder
    reviews_info[:last_approval] = last_approved.approved_at.to_s if last_approved
    reviews_info
  end

  def get_human_reviews
    monkeyci = GithubUser.find_by(login: "monkeyci")
    @pull_request.pull_request_reviews.where.not(github_user: monkeyci)
  end

  def first_responder
    @reviews.min_by(&:created_at)
  end

  def last_approved
    @reviews.where.not(approved_at: nil).max_by(&:approved_at)
  end
end
