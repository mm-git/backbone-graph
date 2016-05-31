'use strict';

var $ = require('jquery');
var Graph = require('../index.js');

var LINE_COLOR = "#ffcc00";
var PEAK_COLOR = "#ff0000";
var AXIS_COLOR = "#7bbcd8";
var SCALE_COLOR = "#666666";

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
  pos: [0, 0, 600, 400],
  xAxis: new Graph.Axis(100, 50, 10),
  yAxis: new Graph.Axis(1000, 100, 100),
  axisColor: AXIS_COLOR,
  scaleColor: SCALE_COLOR
});

graphView.$el.appendTo($('#graphsample'));
graphCollection.change();

var toggleButton = $("#togglesmooth")
toggleButton.on('click', function(){
  if(lineGraph.isSmooth){
    toggleButton.val("Smooth");
    lineGraph.unsmooth();
    graphCollection.change()
  }
  else{
    toggleButton.val("Unsmooth");
    lineGraph.smooth(1, 5);
    lineGraph.calculatePeak(1000, 0.01)
    graphCollection.change()
  }
});