'use strict';

var $ = require('jquery');
var Graph = require('../index.js');

var LINE_COLOR = "#ffcc00";
var PEAK_COLOR = "#ff0000";
var AXIS_COLOR = "#7bbcd8";

var lineGraph = new Graph.LineData({
  lineColor: LINE_COLOR,
  peakColor: PEAK_COLOR
});

var graphCollection = new Graph.Collection([lineGraph]);

var graphSample = [
  [0, 100],
  [10, 200],
  [20, 400],
  [30, 350],
  [40, 500],
  [50, 600],
  [60, 550],
  [70, 1000],
  [80, 200],
  [90, 50],
  [100, 300]
];

graphSample.forEach(function (point){
  lineGraph.addPoint(new Graph.Point(point[0], point[1]));
});

var graphView = new Graph.GraphView({
  collection: graphCollection,
  width: 600,
  height: 400,
  xAxis: new Graph.Axis({max:100, interval:50, subInterval:10, axisColor: AXIS_COLOR}),
  yAxis: new Graph.Axis({max:1000, interval:100, subInterval:100, axisColor: AXIS_COLOR}),
  range: {
    color: AXIS_COLOR,
    opacity: 0.5  
  }
});

graphView.$el.appendTo($('#graphsample'));
graphCollection.change();

var toggleButton = $("#togglesmooth");
toggleButton.on('click', function(){
  if(lineGraph.isSmooth){
    toggleButton.html("Smooth");
    lineGraph.unsmooth();
    graphCollection.change();
    writeInformation();
  }
  else{
    toggleButton.html("Unsmooth");
    lineGraph.smooth(1, 5, 1000, 0.01);
    graphCollection.change();
    writeInformation();
  }
});

var writeInformation = function(){
  var info = "max : " + lineGraph.max.y.toFixed(0) + "(x=" + lineGraph.max.x + ")<br/>" +
             "min : " + lineGraph.min.y.toFixed(0) + "(x=" + lineGraph.min.x + ")<br/><br/>";

  if (lineGraph.isSmooth) {
    var smooth = lineGraph.smoothStatistics;

    info =
      "max : " + smooth.max.y.toFixed(0) + "(x=" + smooth.max.x + ")<br/>" +
      "min : " + smooth.min.y.toFixed(0) + "(x=" + smooth.min.x + ")<br/><br/>" +
      "total gain : " + smooth.gain.toFixed(0) + "<br/>" +
      "total drop : " + smooth.drop.toFixed(0) + "<br/>" +
      "max incline : " + (smooth.incline.max.incline).toFixed(1) + "% (x=" + smooth.incline.max.point.x + ")<br/>" +
      "min incline : " + (smooth.incline.min.incline).toFixed(1) + "% (x=" + smooth.incline.min.point.x + ")<br/><br/>";
  }

  if (lineGraph.isRangeSelected) {
    var range = lineGraph.rangeStatistics;

    info = info +
      "range : " + range.start + " - " + range.end + "<br/>" +
      "gain : " + range.gain.toFixed(0) + "<br/>" +
      "drop : " + range.drop.toFixed(0) + "<br/>" +
      "max incline : " + (range.incline.max.incline).toFixed(1) + "% (x=" + range.incline.max.point.x + ")<br/>" +
      "min incline : " + (range.incline.min.incline).toFixed(1) + "% (x=" + range.incline.min.point.x + ")<br/><br/>" +
      "ave incline : " + (range.incline.ave).toFixed(1) + "%<br/>";
  }

  $('#information').html(info)
};

writeInformation();
