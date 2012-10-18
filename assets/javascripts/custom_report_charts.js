function chart() {
  function chart(selection) {
    selection.each(function() {
      var chartType = this.dataset.chart_type;
      var chartData = JSON.parse(this.dataset.chart_data);
      var data = [
        {
          key: "Chart",
          values: chartData
        }
      ];
      var svg = d3.select(this).select("svg");
      switch (chartType) {

        case "pie":
          nv.addGraph(function() {
            var nvChart = nv.models.pieChart()
                .x(function(d) { return d.label })
                .y(function(d) { return d.value })
                .showLabels(true);

            svg.datum(data)
                .transition().duration(1200)
                .call(nvChart);

            return nvChart;
          });
          break;

        case "donut":
          nv.addGraph(function() {
            var nvChart = nv.models.pieChart()
                .x(function(d) { return d.label })
                .y(function(d) { return d.value })
                .showLabels(true)
                .donut(true);

            svg.datum(data)
                .transition().duration(1200)
                .call(nvChart);

            return nvChart;
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
                .tickFormat(d3.format(',.2f'));

            svg.datum(data)
                .transition().duration(500)
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
                .transition().duration(500)
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

d3.select("#custom-report").call(chart());
