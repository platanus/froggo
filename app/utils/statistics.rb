module Statistics
  extend self

  def mean(array)
    return nil if array.empty?

    array.sum.to_f / array.length
  end

  def variance(array)
    return nil if array.empty?

    mean = mean array
    array.map { |number| (number - mean)**2 }.sum.to_f / array.length
  end

  def standard_deviation(array)
    return nil if array.empty?

    Math::sqrt(variance(array))
  end
end
