jQuery(document).ready(function($) {

  var containerName = 'custom-report';
  var containerId = '#' + containerName;
  var chartType = $(containerId).data('chart_type');
  var chartData = $(containerId).data('chart_data');

  switch (chartType) {
     case 'line':
        var chartXkey = $(containerId).data('chart_xkey');
        var chartYkeys = $(containerId).data('chart_ykeys');
        var chartLabels = $(containerId).data('chart_labels');

        // Morris.Line({
        //   element: containerName,
        //   data: chartData,
        //   xkey: chartXkey,
        //   ykeys: chartYkeys,
        //   labels: chartLabels
        // });

        Morris.Line({
          element: containerName,
          // data: [
          //   {y: '2012', a: 100},
          //   {y: '2011', a: 75},
          //   {y: '2010', a: 50},
          //   {y: '2009', a: 75},
          //   {y: '2008', a: 50},
          //   {y: '2007', a: 75},
          //   {y: '2006', a: 100}
          // ],
          data: [
            {label:1,value:2},
            {label:2,value:2},
            {label:3,value:1}
          ],
          xkey: 'label',
          ykeys: ['value'],
          labels: chartLabels
        });        
        break
     case 'donut':
        Morris.Donut({
          element: containerName,
          data: chartData
        });
        break
     default:
        alert("Undefined chart_type: " + chartType)
        break
  }

});
