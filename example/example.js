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
    lineGraph.smooth(1, 5);
    lineGraph.calculatePeak(1000, 0.01);
    lineGraph.calculateTotalGainAndDrop();
    graphCollection.change();
    writeInformation();
  }
});

var writeInformation = function(){
  var info = "max : " + lineGraph.max.y.toFixed(0) + "(x=" + lineGraph.max.x + ")<br/>" +
             "min : " + lineGraph.min.y.toFixed(0) + "(x=" + lineGraph.min.x + ")<br/><br/>";

  if (lineGraph.isSmooth) {
    info =
      "max : " + lineGraph.smoothMax.y.toFixed(0) + "(x=" + lineGraph.smoothMax.x + ")<br/>" +
      "min : " + lineGraph.smoothMin.y.toFixed(0) + "(x=" + lineGraph.smoothMin.x + ")<br/><br/>" +
      "total gain : " + lineGraph.totalGain.toFixed(0) + "<br/>" +
      "total drop : " + lineGraph.totalDrop.toFixed(0) + "<br/>" +
      "max incline : " + (lineGraph.maxIncline.incline * 100).toFixed(1) + "% (x=" + lineGraph.maxIncline.point.x + ")<br/>" +
      "min incline : " + (lineGraph.minIncline.incline * 100).toFixed(1) + "% (x=" + lineGraph.minIncline.point.x + ")<br/>";
  }
  
  $('#information').html(info)
};

writeInformation();
