ActiveAdmin.register_page "Metrics" do
  menu priority: 1, label: I18n.t("active_admin.assignationMetrics.metrics")
  sidebar I18n.t("active_admin.assignationMetrics.filter") do
    form_for :date, { url: url_for, method: :get } do |f|
      div do
        I18n.t("active_admin.assignationMetrics.from")
      end
      div do
        date_field  :date, :start_date,
                    name: :start_date,
                    max: Time.zone.today,
                    value: params[:start_date]
      end
      div do
        I18n.t("active_admin.assignationMetrics.to")
      end
      div do
        date_field  :date, :end_date,
                    name: :end_date,
                    min: params[:start_date],
                    max: Time.zone.today,
                    value: params[:end_date]
      end
      div do
        f.submit I18n.t("active_admin.assignationMetrics.check")
      end
    end
  end
  content title: I18n.t("active_admin.assignationMetrics.metrics") do
    def day_to_week(day)
      "#{day.strftime('%d %m %Y')} - #{(day + 6.days).strftime('%d %m %Y')}"
    end

    @records = AssignationMetric.order('date_trunc_week_created_at DESC')

    if params[:start_date].present?
      @records = @records.where('created_at >= ?', params[:start_date])
    end

    if params[:end_date].present?
      @records = @records.where('created_at < ?', params[:end_date])
    end

    panel I18n.t("active_admin.assignationMetrics.metrics") do
      columns do
        column do
          table do
            th do
              I18n.t("active_admin.assignationMetrics.week")
            end
            th do
              I18n.t("active_admin.assignationMetrics.quantity")
            end
            @records.group("DATE_TRUNC('week', created_at)").count.each do |week, value|
              tr do
                td day_to_week(week)
                td value
              end
            end
          end
        end
      end
    end
  end
end
