module CustomReportsHelper
  def chart_tag(custom_report)
    case custom_report.chart_type

    when CustomReport::LINE_CHART
      content_tag :div, "", id: "custom-report",
        "data-chart_type" => @custom_report.chart_type, 
        "data-chart_xkey" => @custom_report.xkey.to_json, 
        "data-chart_ykeys" => @custom_report.ykeys.to_json, 
        "data-chart_labels" => @custom_report.labels.to_json, 
        "data-chart_data" => @custom_report.data.to_json

    when CustomReport::DONUT_CHART
      content_tag :div, "", id: "custom-report",
        "data-chart_type" => @custom_report.chart_type, 
        "data-chart_data" => @custom_report.data.to_json

    else
      raise "unknown chart_type: #{custom_report.chart_type}"  
    end
  end
end
