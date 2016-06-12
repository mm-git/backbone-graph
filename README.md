# Backbone.js module of drawing line graph 
[![NPM](https://nodei.co/npm/backbone-graph.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/backbone-graph/)

[![npm version](https://badge.fury.io/js/backbone-graph.svg)](https://badge.fury.io/js/backbone-graph)
[![Build Status](https://travis-ci.org/mm-git/backbone-graph.svg?branch=master)](https://travis-ci.org/mm-git/backbone-graph)
[![Code Climate](https://codeclimate.com/github/mm-git/backbone-graph/badges/gpa.svg)](https://codeclimate.com/github/mm-git/backbone-graph)

This is Backbone.js view, model and collection class for drawing HTML5(canvas) line graph.

## Install

```
npm install backbone-graph
```

## How to use it

### javascript

```javascript
// require
var $ = require('jquery');
var Graph = require('backbone-graph');

// initialize graph data
var lineData = new Graph.LineData({
  lineColor: "#ffcc00",
  peakColor: "#ffffff"
});

// add point to graph data
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
  lineData.addPoint(new Graph.Point(point[0], point[1]));
});

// add graph data to collection
var graphCollection = new Graph.Collection([lineData]);

// initialize graph view
var graphView = new Graph.GraphView({
  collection: graphCollection,
  width: 600,
  height: 400,
  xAxis: new Graph.Axis({max:100, interval:50, subInterval:10, axisColor: AXIS_COLOR}),
  yAxis: new Graph.Axis({max:1000, interval:100, subInterval:100, axisColor: AXIS_COLOR}),
});
graphView.$el.appendTo($('#graphelement'));

// call change() function to redraw graph 
graphCollection.change();
```

### style sheet (css)

- backbone-graph.css

    link backbone-graph.css or backbone-graph.min.css in the header section of your html file.
    
    `<link rel="stylesheet" href="dist/css/backbone-graph.css">`

- user customize

```css
/* You can change the magnification button position */
.backbone_graph_scale {
    left: 485px;
    top: 0;
}

/* You can change the magnification button appearance */
.backbone_graph_scale_button {
    background: #7bbcd8;
    color: #fff;
}

/* You can change the magnification number appearance */
.backbone_graph_scale_number {
    background: #fcfcfc;
    color: #000;
}
```

## Graph sample

Normal graph

![Graph sample](./example/graph.png?raw=true "Graph sample")

Smoothed graph

![Graph sample](./example/smoothgraph.png?raw=true "Smoothed graph sample")

## How to operate the Graph 

- Magnification

    You can change the graph magnification to click the plus / minus button at top of the graph.
    The magnification can be changed every 50%, and maximum is 800%.

- Scroll

    You can scroll the graph to drag around the x axis.

## Other functions

### Graph.LineData.smooth(interval, range)

  `interval` : Before smoothing graph data, each data should have same interval. So this function re-sample the data with interval parameter.
  `range` : This function calculate moving average to smooth the graph data. `range` is the range of moving average.  

```javascript
// First this function re-sample the data with interval 1, 
// Next function calcurate moving average.  
lineData.smooth(1, 10); 
```

### Graph.LineData.calculatePeak(xyRatio, threshold)

  Before using this function, it is necessary to call `smooth()`
  `xyRatio` : Ratio of x axis unit and y axis unit. For instance, if x axis unit is **KM** and y is **m** then xyRatio should be 1000. 
  `threshold` : This function calculate peak of the graph by checking change of inclination. `threshold` is limit value of inclination.
  
```javascript
lineData.calculatePeak(1000, 0.01); 
console.log(lineData.peakList);     // you can get peak data array
```

### Graph.LineData.calculateTotalGainAndDrop()

  Before using this function, it is necessary to call `calculatePeak()`

```javascript
lineData.calculateTotalGainAndDrop(); 
console.log(lineData.totalGain);     // you can get total gain
console.log(lineData.totalDrop);     // you can get total drop
```

### Graph.LineData.unsmooth()

  clear the calculated smooth data, peak, total gain and drop.

```javascript
lineData.unsmooth(); 
```

