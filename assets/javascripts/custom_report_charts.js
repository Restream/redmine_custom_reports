jQuery(document).ready(function($){

  function chart() {
    function chart(selection) {
      selection.each(function() {

        var info = $(this).closest('.custom-report').data().custom_report_info;
        var data = $(this).data().chart_data;
        var svg = d3.select(this).select("svg");

        switch (info.chart_type) {

          case "undev_pie":

            nv.addGraph(function() {
              var chart = nv.models.undevPieChart()
                  .x(function(d) { return d.label })
                  .y(function(d) { return d.value })
                  .showLabels(true);

              svg.datum(data)
                  .transition()
                  .duration(1200)
                  .call(chart);

              nv.utils.windowResize(chart.update);

              return chart;
            });

            break;

          case "pie":

            nv.addGraph(function() {
              var chart = nv.models.pieChart()
                  .x(function(d) { return d.label })
                  .y(function(d) { return d.value })
                  .showLabels(true);

              svg.datum(data)
                  .transition()
                  .duration(1200)
                  .call(chart);

              nv.utils.windowResize(chart.update);

              return chart;
            });

            break;

          case "donut":
            nv.addGraph(function() {
              var chart = nv.models.pieChart()
                  .x(function(d) { return d.label })
                  .y(function(d) { return d.value })
                  .showLabels(false)
                  .donut(true);

              svg.datum(data)
                  .transition()
                  .duration(1200)
                  .call(chart);

              nv.utils.windowResize(chart.update);

              return chart;
            });
            break;

          case "horizontal_bar":
            nv.addGraph(function() {
              var chart = nv.models.multiBarHorizontalChart()
                  .x(function(d) { return d.label })
                  .y(function(d) { return d.value })
                  .margin({top: 30, right: 20, bottom: 50, left: 175})
                  .showValues(true)
                  .tooltips(false)
                  .showControls(false);

              chart.yAxis
                  .tickFormat(d3
                  .format(',.2f'));

              svg.datum(data)
                  .transition()
                  .duration(500)
                  .call(chart);

              nv.utils.windowResize(chart.update);

              return chart;
            });
            break;

          case "bar":
            nv.addGraph(function() {
              var chart = nv.models.discreteBarChart()
                  .x(function(d) { return d.label })
                  .y(function(d) { return d.value })
                  .staggerLabels(true)
                  .tooltips(false)
                  .showValues(true);

              svg.datum(data)
                  .transition()
                  .duration(500)
                  .call(chart);

              nv.utils.windowResize(chart.update);

              return chart;
            });
            break;

          case "stacked_bar":
            nv.addGraph(function() {
              var chart = nv.models.multiBarChart()
                  .x(function(d) { return d.label })
                  .y(function(d) { return d.value });

              chart.xAxis
                  .axisLabel(info.group_by_caption);

              svg.datum(data)
                  .transition()
                  .duration(500)
                  .call(chart);

              nv.utils.windowResize(chart.update);

              return chart;
            });
            break;

          default:
            throw "unknown chart type " + chartType;
        }
      })
    }
    return chart;
  }

  $('.custom-report').each(function() {
    var info = $(this).data().custom_report_info;
    if (info.multi_series) {
      var report_height = document.body.clientHeight * 0.8;
      $(this).children('.custom-report-chart').css('height', report_height);
    }
  });

  d3.selectAll(".custom-report-chart").call(chart());

});
