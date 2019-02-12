class ContributionRanker::ComputeScore <
  PowerTypes::Command.new(:self_reviewed_prs, :per_user_reviews)
  # rubocop:disable Metrics/AbcSize
  def perform
    return 0 unless user_reviewed_someone_else?

    stats = compute_stats
    zeros_penalty = @per_user_reviews.count(0) * stats[:sqrt_mean]
    std_penalty =
      stats[:mean] * Math::sqrt((stats[:std] - stats[:non_zeros_std])**2)
    (
      @self_reviewed_prs * stats[:sqrt_mean] +
      stats[:sqrt_mean] +
      stats[:std] +
      std_penalty +
      zeros_penalty * 4.5 +
      (stats[:mean] - @per_user_reviews.min) * 11 +
      1
    ) * (1 / stats[:sqrt_mean])
  end
  # rubocop:enable Metrics/AbcSize

  private

  def compute_stats
    mean = Statistics::mean @per_user_reviews
    std = Statistics::standard_deviation @per_user_reviews
    {
      mean: mean,
      sqrt_mean: Math::sqrt(mean),
      std: std,
      sqrt_std: Math::sqrt(std),
      non_zeros_std: Statistics::standard_deviation(
        non_zeros(@per_user_reviews)
      )
    }
  end

  def user_reviewed_someone_else?
    !(non_zeros @per_user_reviews).empty?
  end

  def non_zeros(list_of_numbers)
    list_of_numbers.reject(&:zero?)
  end
end
