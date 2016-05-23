'use strict';

var Graph = {
  Collection: require('./src/Model/graphDataCollection.coffee'),
  LineData: require('./src/Model/graphLineData.coffee'),
  PointData: require('./src/Model/graphPointData.coffee'),
  Point: require('./src/Model/graphPoint.coffee'),
  Axis: require('./src/Model/axis.coffee'),
  GraphView: require('./src/View/graphView.coffee'),
  AxisView: require('./src/View/axisView.coffee')
};

module.exports = Graph;
