class CorrelationMatrix
  attr_accessor :row_head, :col_head, :data

  def initialize(users)
    @row_head = users
    @col_head = users
    @pos_hash = Hash[users.map(&:id).map.with_index { |x, i| [x, i] }]
    @data = Hash.new(0)
  end

  def fill_matrix
    @row_head.each_with_index do |user, index|
      user.interactions.each { |key, value| @data[[index, @pos_hash[key]]] += value }
    end
  end
end
