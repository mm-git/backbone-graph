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
  xAxis: { max:100, interval:50, subInterval:10, axisColor: AXIS_COLOR },
  yAxis: { max:1000, interval:100, subInterval:100, axisColor: AXIS_COLOR },
  range: { color: AXIS_COLOR, opacity: 0.5 }
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

    You can change the graph magnification to click the plus / minus button at the top of the graph.
    The magnification can be changed every 50%, and maximum is 800%.


- Scroll

    You can scroll the graph to drag around the x axis.


- Select range

    You can select the graph range that you want to check in detail. 
    To drag the graph area, you can select the range. After selecting , you can adjust the range to drag the edge of the range. And you can move to drag the center of the range. 


## Other functions

### Graph.LineData.smooth(interval, range, xyRatio, threshould)

   `interval` : Before smoothing graph data, each data should have same interval. So this function re-sample the data with interval parameter.

   `range` : This function calculate moving average to smooth the graph data. `range` is the range of moving average.  

   `xyRatio` : Ratio of x axis unit and y axis unit. For instance, if x axis unit is **KM** and y is **m** then xyRatio should be 1000. 

   `threshold` : This function calculate peak of the graph by checking change of inclination. `threshold` is limit value of inclination.


```javascript
// First this function re-sample the data with interval 1, 
// Next function calcurate moving average.  
lineData.smooth(1, 10, 1000, 0.01); 
console.log(lineData.peakList);                  // you can get peak data array
console.log(lineData.smoothStatictics.gain);     // you can get total gain
console.log(lineData.smoothStatictics.drop);     // you can get total drop
```

### Graph.LineData.unsmooth()

  clear the calculated smooth data, peak, total gain and drop.

```javascript
lineData.unsmooth(); 
```

## Properties

| class                            | property         | type        | detail                                |
|----------------------------------|------------------|-------------|---------------------------------------|
| Graph.PointData / Graph.LineData | max              | Graph.Point | Maximum Graph.Point before smoothing. |
|                                  | min              | Graph.Point | Minimum Graph.Point before smoothing. |
|                                  | xMax             | number      | maximum x                             |
| Graph.LineData                   | isSmooth         | boolean     | Whether line data is smoothed or not. |
|                                  | smoothStatistics | Object      | `*1`                                  |
|                                  | isRangeSelected  | boolean     | Whether range is selected or not.     |
|                                  | rangeStatistics  | Object      | `*2`                                  |


- `*1` Graph.LineData.smoothStatistics

```
Graph.LineData.smoothStatistics = {
  max : {               // Maximum Graph.Point after smoothing
    x : number,
    y : number
  },
  min : {               // Minimum Graph.Point after smoothing
    x : number,
    y : number
  },
  gain : number,        // total gain
  drop : number,        // total drop
  incline: {
    max : {
      incline: number,  // %
      point : {
        x : number,
        y : number            
      }
    },
    min : {
      incline: number,  // %
      point : {
        x : number,
        y : number            
      }
    },
    ave : incline       // %
  }
};
```


- `*2` Graph.LineData.rangeStatistics

```
Graph.LineData.smoothStatistics = {
  start : number,       // x value of range start
  start : number,       // x value of range end
  width : number,       // range width
  max : {               // Maximum Graph.Point of range
    x : number,
    y : number
  },
  min : {               // Minimum Graph.Point of range
    x : number,
    y : number
  },
  gain : number,        // total gain
  drop : number,        // total drop
  incline: {
    max : {
      incline: number,  // %
      point : {
        x : number,
        y : number            
      }
    },
    min : {
      incline: number,  // %
      point : {
        x : number,
        y : number            
      }
    },
    ave : incline       // %
  }
};
```

## Event

| class           | event           | parameter        | when event triggers                                      |
|-----------------------------------|------------------|----------------------------------------------------------|
| Graph.LineData  | changeSelection | none             | Selected range is changed or unselected                  |
| Graph.PointData | click           | index, screenPos | Point is clicked                                         |
|                 | mouseenter      | index, screenPos | Mouse cursor enter the point                             |
|                 | mouseleave      | index            | Mouse cursor leave from the point or any area is clicked |
