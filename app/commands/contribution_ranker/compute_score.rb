class ContributionRanker::ComputeScore < 
  PowerTypes::Command.new(:self_reviewed_prs, :per_user_reviews)
  def perform
    return 0 unless user_reviewed_someone_else?
    stats = compute_stats
    (
      @self_reviewed_prs * stats[:sqrt_mean] + \
      stats[:sqrt_mean] + \
      stats[:std] + \
      stats[:mean] + Math.sqrt((stats[:std] - stats[:non_zeros_std])**2) + \
      @per_user_reviews.count(0) * stats[:sqrt_mean] * 4.5 + \
      (stats[:mean] - @per_user_reviews.min) * 11 + \
      1
    ) * (1 / stats[:sqrt_mean])
  end

  private
  
  def compute_stats
    mean = @per_user_reviews.mean
    std = @per_user_reviews.standard_deviation
    {
      mean: mean,
      sqrt_mean: Math.sqrt(mean),
      std: std,
      sqrt_std: Math.sqrt(std),
      non_zeros_std: (non_zeros @per_user_reviews).standard_deviation,
    }
  end

  def user_reviewed_someone_else?
    not (non_zeros @per_user_reviews).empty?
  end

  def non_zeros(list_of_numbers)
    list_of_numbers.reject(&:zero?)
  end
end
