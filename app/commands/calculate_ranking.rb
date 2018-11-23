class CalculateRanking < PowerTypes::Command.new(:data, :size, :limit)
  def perform
    @users_prs = {}
    build_lists
    calculate_top_ranking(@limit)
  end

  private

  def ranking(array)
    own_prs, *list = array
    non_zeros = list.reject(&:zero?)
    return 9999 if list.empty? || non_zeros.empty?
    stats = calculate_statistics(list, non_zeros)
    std_penalization =  stats['mean'] * Math.sqrt((stats['std'] - stats['non_zeros_std'])**2)
    zero_penalization = list.count(0) * stats['sq_mean']
    ponderate(stats, own_prs, std_penalization, zero_penalization)
  end

  def calculate_statistics(list, non_zeros)
    mean = calculate_mean(list)
    mean_no_zeros = calculate_mean(non_zeros)
    stats = {}
    stats['mean'] = mean
    stats['sq_mean'] = Math.sqrt(stats['mean'])
    stats['std'] = standard_deviation(list, stats['mean'])
    stats['non_zeros_std'] = standard_deviation(non_zeros, mean_no_zeros)
    stats['mean_min_diff'] = stats['mean'] - list.min
    stats
  end

  def ponderate(stats, own_prs, std_penalization, zero_penalization)
    (own_prs * stats['sq_mean'] + stats['sq_mean'] * stats['std'] + std_penalization +
    4.5 * zero_penalization + 11 * stats['mean_min_diff'] + 1) *
      (1 / stats['sq_mean'])
  end

  def standard_deviation(list, mean)
    return 0 if list.empty?
    return 9999 if mean.zero?
    sum_of_squared_differences = list.map { |i| (i - mean)**2 }.reduce(:+)
    Math.sqrt(sum_of_squared_differences / list.length)
  end

  def calculate_mean(list)
    return 0 if list.empty?
    list.reduce(:+) / list.length.to_r
  end

  def build_lists
    (0...@size).each do |x|
      @users_prs[x] = []
      (0...@size).each do |y|
        @users_prs[x] << @data[[x, y]] if x != y
      end
      @users_prs[x].insert(0, @data[[x, x]])
    end
  end

  def calculate_top_ranking(limit)
    Hash[@users_prs.sort_by { |_k, v| ranking(v) }.first(limit)].keys
  end
end
