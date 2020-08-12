module ReviewsTimespansHelper
  def timespans
    [1, 3, 6, 9, 12]
  end

  def timespans_with_name
    timespans.map { |months| { name: t('messages.dashboard.month', count: months), limit: months } }
  end
end
