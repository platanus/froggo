class CalulateVariance < PowerTypes::Command.new(:data, :size, :limit)
  def perform
    @users_prs = {}
    build_lists
    calculate_top_variances(@limit)
  end

  private

  def variance(list)
    return 0 if list.empty?
    mean = list.reduce(:+) / list.length.to_r
    sum_of_squared_differences = list.map { |i| (i - mean)**2 }.reduce(:+)
    sum_of_squared_differences / list.length
  end

  def build_lists
    (0...@size).each do |y|
      @users_prs[y] = []
      (0...@size).each do |x|
        @users_prs[y] << @data[[x, y]] if x != y
      end
    end
  end

  def calculate_top_variances(limit)
    Hash[@users_prs.sort_by { |_k, v| variance(v) }.first(limit)].keys
  end
end
