module TimespansHelper
  def timespans_options
    { 'one_month': 1, 'three_months': 3, 'six_months': 6, 'nine_months': 9, 'twelve_months': 12 }
  end

  def timespans_options_with_name
    timespans_options.map do |key, limit| {
      key: key,
      value: I18n.t("activerecord.enums.timespans.limits.#{key}"),
      limit: limit
    }
    end
  end
end
