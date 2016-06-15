#
# User: code house
# Date: 2016/06/07
#
require('./viewTest')
assert = require('assert')
fs = require('fs')

AxisData = require('../../src/Model/axisData')
GraphLineData = require('../../src/Model/graphLineData')
GraphPointData = require('../../src/Model/graphPointData')
GraphPoint = require('../../src/Model/graphPoint')
GraphDataCollection = require('../../src/Model/graphDataCollection')
graphView = require('../../src/View/graphView')


describe 'GraphView Class Test', ->
  beforeEach ->
    lineGraph = new GraphLineData({
      lineColor: "#ffcc00",
      peakColor: "#ff0000"
    })
    pointGraph = new GraphPointData({
      pointColor: "#ff0000"
    })

    [
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
    ]
    .forEach((point) =>
      lineGraph.addPoint(new GraphPoint(point[0], point[1]))
      pointGraph.addPoint(new GraphPoint(point[0], point[1]))
    )

    @collection = new GraphDataCollection([lineGraph, pointGraph]);
    @xAxis = new AxisData({max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    @yAxis = new AxisData({max:1000, interval:100, subInterval:100, axisColor: "#7bbcd8"})

    @graphView = new graphView({
      collection: @collection
      width: 600
      height: 400
      xAxis: @xAxis
      yAxis: @yAxis
      range: {
        color: "#7bbcd8",
        opacity: 0.5
      }
    })
    
  it 'constructor test', ->
    assert.equal(@graphView.width, 600)
    assert.equal(@graphView.height, 400)
    assert.equal(@graphView.xAxis, @xAxis)
    assert.equal(@graphView.yAxis, @yAxis)

    assert.equal(@graphView.$el.prop('tagName'), 'DIV')
    assert.equal(@graphView.$el.css('left'), '0px')
    assert.equal(@graphView.$el.css('top'), '0px')
    assert.equal(@graphView.$el.css('width'), '600px')
    assert.equal(@graphView.$el.css('height'), '400px')

    assert.equal(@graphView.$el[0].childNodes.length, 5)
    assert.equal(@graphView.$el[0].childNodes[0].tagName, "DIV")
    assert.equal(@graphView.$el[0].childNodes[1].tagName, "DIV")
    assert.equal(@graphView.$el[0].childNodes[2].tagName, "DIV")
    assert.equal(@graphView.$el[0].childNodes[3].tagName, "DIV")
    assert.equal(@graphView.$el[0].childNodes[4].tagName, "DIV")

