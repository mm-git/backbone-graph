'use strict';

var $ = require('jquery');
var Graph = require('../index.js');

var LINE_COLOR = "#ffcc00";
var PEAK_COLOR = "#ff0000";
var POINT_COLOR = "#ff3333";
var AXIS_COLOR = "#7bbcd8";

var writeInformation = function(){
  var info = "max : " + lineGraph.max.y.toFixed(0) + "(x=" + lineGraph.max.x + ")<br/>" +
    "min : " + lineGraph.min.y.toFixed(0) + "(x=" + lineGraph.min.x + ")<br/><br/>";

  if (lineGraph.isSmooth) {
    var smooth = lineGraph.smoothStatistics;

    info =
      "max : " + smooth.max.y.toFixed(0) + "(x=" + smooth.max.x + ")<br/>" +
      "min : " + smooth.min.y.toFixed(0) + "(x=" + smooth.min.x + ")<br/>" +
      "total gain : " + smooth.gain.toFixed(0) + "<br/>" +
      "total drop : " + smooth.drop.toFixed(0) + "<br/>" +
      "max incline : " + (smooth.incline.max.incline).toFixed(1) + "% (x=" + smooth.incline.max.point.x + ")<br/>" +
      "min incline : " + (smooth.incline.min.incline).toFixed(1) + "% (x=" + smooth.incline.min.point.x + ")<br/>" +
      "ave incline : " + (smooth.incline.ave).toFixed(1) + "%<br/><br/>";
  }

  if (lineGraph.isRangeSelected && lineGraph.isSmooth) {
    var range = lineGraph.rangeStatistics;

    info = info +
      "range : " + range.start + " - " + range.end + "<br/>" +
      "max : " + range.max.y.toFixed(0) + "(x=" + range.max.x + ")<br/>" +
      "min : " + range.min.y.toFixed(0) + "(x=" + range.min.x + ")<br/>" +
      "gain : " + range.gain.toFixed(0) + "<br/>" +
      "drop : " + range.drop.toFixed(0) + "<br/>";

    if (range.incline !== undefined) {
      info = info +
        "max incline : " + (range.incline.max.incline).toFixed(1) + "% (x=" + range.incline.max.point.x + ")<br/>" +
        "min incline : " + (range.incline.min.incline).toFixed(1) + "% (x=" + range.incline.min.point.x + ")<br/>" +
        "ave incline : " + (range.incline.ave).toFixed(1) + "%<br/>";
    }
  }

  $('#information').html(info)
};

var lineGraph = new Graph.LineData({
  lineColor: LINE_COLOR,
  peakColor: PEAK_COLOR
})
.on({
  changeSelection :function(){
    writeInformation();
  }
});

var pointGraph = new Graph.PointData({
  pointColor: POINT_COLOR,
  pointShape: Graph.PointData.SHAPE.DOWNWARD_TRIANGLE
})
.on({
  click: function(index, screenPos){
    console.log("click point index=" + index + " , pos=" + JSON.stringify(screenPos))
  },
  mouseenter: function(index, screenPos){
    console.log("mouseenter point index=" + index + " , pos=" + JSON.stringify(screenPos))
  },
  mouseleave: function(index){
    console.log("mouseleave point index=" + index)
  }
});

var graphCollection = new Graph.Collection([lineGraph, pointGraph]);

var lineGraphSample = [
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

lineGraphSample.forEach(function (point){
  lineGraph.addPoint(new Graph.Point(point[0], point[1]));
});

var pointGraphSample = [
  [0, 800, "#ff0000", Graph.PointData.SHAPE.CIRCLE],
  [10, 700, "#ff3333", Graph.PointData.SHAPE.CIRCLE],
  [20, 600, "#ff6666", Graph.PointData.SHAPE.TRIANGLE],
  [30, 500, "#ff9999", Graph.PointData.SHAPE.TRIANGLE],
  [40, 500, "#ffcccc", Graph.PointData.SHAPE.DOWNWARD_TRIANGLE],
  [50, 400, "#ffffff", Graph.PointData.SHAPE.DOWNWARD_TRIANGLE],
  [60, 500, "#ffcccc", Graph.PointData.SHAPE.SQUARE],
  [70, 700, "#ff9999", Graph.PointData.SHAPE.SQUARE],
  [80, 800, "#ff6666", Graph.PointData.SHAPE.DIAMOND],
  [90, 900, "#ff3333", Graph.PointData.SHAPE.DIAMOND],
  [100, 700, "#ff0000", undefined]
];

pointGraphSample.forEach(function (point){
  pointGraph.addPoint(new Graph.Point(point[0], point[1]), point[2], point[3]);
});

var graphView = new Graph.GraphView({
  collection: graphCollection,
  width: 600,
  height: 400,
  xAxis: {
    max: 100,
    interval: 50,
    subInterval: 10,
    axisColor: AXIS_COLOR
  },
  yAxis: {
    max:1000,
    interval:100,
    subInterval:100,
    axisColor: AXIS_COLOR
  },
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

writeInformation();

