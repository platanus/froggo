class CalulateVariance < PowerTypes::Command.new(:data, :size)
  def perform
    min_index = -1
    min_var = 9999
    (0...@size).each do |x|
      all_prs = []
      (0...@size).each do |y|
        all_prs << @data[[x, y]] if x != y
      end
      var = variance(all_prs)
      if var <= min_var
        min_index = x
        min_var = var
      end
    end
    puts min_index
    min_index
  end

  private

  def variance(list)
    return 0 if list.empty?
    mean = list.reduce(:+) / list.length.to_r
    sum_of_squared_differences = list.map { |i| (i - mean)**2 }.reduce(:+)
    sum_of_squared_differences / list.length
  end
end
