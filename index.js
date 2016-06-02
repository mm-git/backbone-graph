'use strict';

var Graph = {
  Collection: require('./lib/Model/graphDataCollection'),
  LineData: require('./lib/Model/graphLineData'),
  PointData: require('./lib/Model/graphPointData'),
  Point: require('./lib/Model/graphPoint'),
  Axis: require('./lib/Model/axisData'),
  GraphView: require('./lib/View/graphView'),
  AxisView: require('./lib/View/axisView')
};

module.exports = Graph;
