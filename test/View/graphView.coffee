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

  it 'event test mousedown(out of scroll range)', ->
    event = $.Event("mousedown", {
      pageX: 0
      pageY: 0
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._scrolling, false)

    event = $.Event("mousedown", {
      pageX: 0
      pageY: 340
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._scrolling, false)

  it 'event test mousedown/move/up', ->
    @graphView._xScaleData.scale = 200

    event = $.Event("mousedown", {
      pageX: 100
      pageY: 341
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._scrolling, true)
    assert.equal(@graphView._lastX, 100)

    event = $.Event("mousemove", {
      pageX: 80
      pageY: 341
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._scrolling, true)
    assert.equal(@graphView._lastX, 80)

    assert.equal(@graphView._graphCanvasView.$el.css("left"), "-20px")
    assert.equal(@graphView._xAxisView.$el.css("left"), "-20px")

    event = $.Event("mousemove", {
      pageX: 120
      pageY: 341
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._scrolling, true)
    assert.equal(@graphView._lastX, 120)

    assert.equal(@graphView._graphCanvasView.$el.css("left"), "0px")
    assert.equal(@graphView._xAxisView.$el.css("left"), "0px")


    event = $.Event("mouseup", {
      pageX: 60
      pageY: 341
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._scrolling, false)

    assert.equal(@graphView._graphCanvasView.$el.css("left"), "-60px")
    assert.equal(@graphView._xAxisView.$el.css("left"), "-60px")

  it 'event test dblclick', ->
    @collection.models[0].smooth(1, 5)
    @collection.models[0].calculatePeak(1000, 0.01)
    @collection.models[0].calculateTotalGainAndDrop()

    event = $.Event("dblclick", {
      pageX: 0
      pageY: 0
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.selected, false)

    event = $.Event("dblclick", {
      pageX: 571
      pageY: 0
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.selected, false)

    event = $.Event("dblclick", {
      pageX: 40
      pageY: 0
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.selected, false)

    event = $.Event("dblclick", {
      pageX: 40
      pageY: 30
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.start, 0)
    assert.equal(@graphView._xRangeData.end, 68)
    assert.equal(@graphView._xRangeData.selected, true)

    event = $.Event("dblclick", {
      pageX: 401
      pageY: 341
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.start, 0)
    assert.equal(@graphView._xRangeData.end, 68)
    assert.equal(@graphView._xRangeData.selected, true)

    event = $.Event("dblclick", {
      pageX: 401
      pageY: 340
    })
    @graphView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.start, 68)
    assert.equal(@graphView._xRangeData.end, 89)
    assert.equal(@graphView._xRangeData.selected, true)
