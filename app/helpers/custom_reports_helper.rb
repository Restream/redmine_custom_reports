module CustomReportsHelper
  def custom_report_div_with_data(custom_report)
    content_tag :div, "", :id => "custom-report",
                "data-chart_type" => custom_report.chart_type,
                "data-chart_data" => custom_report.data.to_json do
      content_tag :svg
    end
  end
end
