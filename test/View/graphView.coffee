#
# User: code house
# Date: 2016/06/07
#
require('./viewTest')
assert = require('assert')
sinon = require('sinon')
fs = require('fs')

AxisData = require('../../src/Model/axisData')
GraphLineData = require('../../src/Model/graphLineData')
GraphPointData = require('../../src/Model/graphPointData')
GraphPoint = require('../../src/Model/graphPoint')
GraphDataCollection = require('../../src/Model/graphDataCollection')
graphView = require('../../src/View/graphView')


describe 'GraphView Class Test', ->
  beforeEach ->
    @lineGraph = new GraphLineData({
      lineColor: "#ffcc00",
      peakColor: "#ff0000"
    })
    @pointGraph = new GraphPointData({
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
      @lineGraph.addPoint(new GraphPoint(point[0], point[1]))
      @pointGraph.addPoint(new GraphPoint(point[0], point[1]))
    )
    @lineGraph.smooth(1, 5, 1000, 0.01)

    @collection = new GraphDataCollection([@lineGraph, @pointGraph]);

    @graphView = new graphView({
      collection: @collection
      width: 600
      height: 400
      xAxis: {max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"}
      yAxis: {max:1000, interval:100, subInterval:100, axisColor: "#7bbcd8"}
      range: {
        color: "#7bbcd8",
        opacity: 0.5
      }
    })
    @collection.change()
    
  it 'constructor test', ->
    assert.equal(@graphView.width, 600)
    assert.equal(@graphView.height, 400)
    assert.deepEqual(@graphView.xAxis, {max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    assert.deepEqual(@graphView.yAxis, {max:1000, interval:100, subInterval:100, axisColor: "#7bbcd8"})
    assert.equal(@graphView.range.color, "#7bbcd8")
    assert.equal(@graphView.range.opacity, 0.5)

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

    assert.equal(@graphView._yAxisView.$wrap.css('left'),   '0px')
    assert.equal(@graphView._yAxisView.$wrap.css('top'),    '0px')
    assert.equal(@graphView._yAxisView.$wrap.css('width'),  '40px')
    assert.equal(@graphView._yAxisView.$wrap.css('height'), '370px')
    assert.equal(@graphView._graphCanvasView.$wrap.css('left'),   '40px')
    assert.equal(@graphView._graphCanvasView.$wrap.css('top'),    '0px')
    assert.equal(@graphView._graphCanvasView.$wrap.css('width'),  '560px')
    assert.equal(@graphView._graphCanvasView.$wrap.css('height'), '370px')
    assert.equal(@graphView._xAxisView.$wrap.css('left'),   '40px')
    assert.equal(@graphView._xAxisView.$wrap.css('top'),    '370px')
    assert.equal(@graphView._xAxisView.$wrap.css('width'),  '560px')
    assert.equal(@graphView._xAxisView.$wrap.css('height'), '30px')
    assert.equal(@graphView._rangeView.$wrap.css('left'),   '40px')
    assert.equal(@graphView._rangeView.$wrap.css('top'),    '0px')
    assert.equal(@graphView._rangeView.$wrap.css('width'),  '560px')
    assert.equal(@graphView._rangeView.$wrap.css('height'), '370px')

    assert.equal(@graphView._yAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._yAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._yAxisView.$el.css('width'),  '40px')
    assert.equal(@graphView._yAxisView.$el.css('height'), '370px')
    assert.equal(@graphView._graphCanvasView.$el.css('left'),   '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('top'),    '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('width'),  '560px')
    assert.equal(@graphView._graphCanvasView.$el.css('height'), '370px')
    assert.equal(@graphView._xAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._xAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._xAxisView.$el.css('width'),  '560px')
    assert.equal(@graphView._xAxisView.$el.css('height'), '30px')
    assert.equal(@graphView._rangeView.$el.css('left'),   '0px')
    assert.equal(@graphView._rangeView.$el.css('top'),    '0px')
    assert.equal(@graphView._rangeView.$el.css('width'),  '560px')
    assert.equal(@graphView._rangeView.$el.css('height'), '370px')

  it 'event test collection:change', ->
    @lineGraph.addPoint(new GraphPoint(110, 1100))
    @lineGraph.smooth(1, 5, 1000, 0.01)
    @collection.change()

    assert.equal(@graphView._xAxisData.max, 110)
    assert.equal(@graphView._yAxisData.max, 1100)

    assert.equal(@graphView._yAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._yAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._yAxisView.$el.css('width'),  '40px')
    assert.equal(@graphView._yAxisView.$el.css('height'), '370px')
    assert.equal(@graphView._graphCanvasView.$el.css('left'),   '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('top'),    '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('width'),  '560px')
    assert.equal(@graphView._graphCanvasView.$el.css('height'), '370px')
    assert.equal(@graphView._xAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._xAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._xAxisView.$el.css('width'),  '560px')
    assert.equal(@graphView._xAxisView.$el.css('height'), '30px')
    assert.equal(@graphView._rangeView.$el.css('left'),   '0px')
    assert.equal(@graphView._rangeView.$el.css('top'),    '0px')
    assert.equal(@graphView._rangeView.$el.css('width'),  '560px')
    assert.equal(@graphView._rangeView.$el.css('height'), '370px')

  it 'event test xScaleData:change', ->
    @graphView._xScaleData.scale = 200

    assert.equal(@graphView._yAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._yAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._yAxisView.$el.css('width'),  '40px')
    assert.equal(@graphView._yAxisView.$el.css('height'), '370px')
    assert.equal(@graphView._graphCanvasView.$el.css('left'),   '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('top'),    '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('width'),  '1120px')
    assert.equal(@graphView._graphCanvasView.$el.css('height'), '370px')
    assert.equal(@graphView._xAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._xAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._xAxisView.$el.css('width'),  '1120px')
    assert.equal(@graphView._xAxisView.$el.css('height'), '30px')
    assert.equal(@graphView._rangeView.$el.css('left'),   '0px')
    assert.equal(@graphView._rangeView.$el.css('top'),    '0px')
    assert.equal(@graphView._rangeView.$el.css('width'),  '1120px')
    assert.equal(@graphView._rangeView.$el.css('height'), '370px')

  it 'event test xOffsetData:change', ->
    @graphView._xScaleData.scale = 400
    @graphView._xOffsetData.scroll(-400)

    assert.equal(@graphView._yAxisView.$el.css('left'),   '0px')
    assert.equal(@graphView._yAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._yAxisView.$el.css('width'),  '40px')
    assert.equal(@graphView._yAxisView.$el.css('height'), '370px')
    assert.equal(@graphView._graphCanvasView.$el.css('left'),   '-400px')
    assert.equal(@graphView._graphCanvasView.$el.css('top'),    '0px')
    assert.equal(@graphView._graphCanvasView.$el.css('width'),  '2240px')
    assert.equal(@graphView._graphCanvasView.$el.css('height'), '370px')
    assert.equal(@graphView._xAxisView.$el.css('left'),   '-400px')
    assert.equal(@graphView._xAxisView.$el.css('top'),    '0px')
    assert.equal(@graphView._xAxisView.$el.css('width'),  '2240px')
    assert.equal(@graphView._xAxisView.$el.css('height'), '30px')
    assert.equal(@graphView._rangeView.$el.css('left'),   '-400px')
    assert.equal(@graphView._rangeView.$el.css('top'),    '0px')
    assert.equal(@graphView._rangeView.$el.css('width'),  '2240px')
    assert.equal(@graphView._rangeView.$el.css('height'), '370px')

  it 'event test xRangeData:change', ->
    @graphView._xRangeData.selectStartX(50)
    @graphView._xRangeData.selectEndX(60)

    assert.equal(@graphView._rangeView.$el.css('left'),   '0px')
    assert.equal(@graphView._rangeView.$el.css('top'),    '0px')
    assert.equal(@graphView._rangeView.$el.css('width'),  '560px')
    assert.equal(@graphView._rangeView.$el.css('height'), '370px')

  it 'event test mouse motion range click', ->
    event = $.Event("mousedown", {pageX: 40, pageY: 30})
    @graphView._gestureView.$el.trigger(event)
    event = $.Event("mouseup", {pageX: 40, pageY: 30})
    @graphView._gestureView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.selected, true)
    assert.equal(@graphView._xRangeData.start, 0)
    assert.equal(@graphView._xRangeData.end, 68)

  it 'event test mouse motion range dragging', ->
    event = $.Event("mousedown", {pageX: 50, pageY: 30})
    @graphView._gestureView.$el.trigger(event)
    event = $.Event("mousemove", {pageX: 60, pageY: 30})
    @graphView._gestureView.$el.trigger(event)
    event = $.Event("mousemove", {pageX: 70, pageY: 30})
    @graphView._gestureView.$el.trigger(event)
    event = $.Event("mouseup",   {pageX: 70, pageY: 30})
    @graphView._gestureView.$el.trigger(event)

    assert.equal(@graphView._xRangeData.selected, true)
    assert.equal(Math.floor(@graphView._xRangeData.start), 3)
    assert.equal(Math.floor(@graphView._xRangeData.end), 5)

  it 'event test mouse motion point click', ->
    trigger = sinon.spy @pointGraph, 'trigger'

    event = $.Event("mousedown", {pageX: 93, pageY: 302})
    @graphView._gestureView.$el.trigger(event)
    event = $.Event("mouseup",   {pageX: 93, pageY: 302})
    @graphView._gestureView.$el.trigger(event)

    assert.equal(trigger.calledOnce, true)
    assert.equal(trigger.getCall(0).args.length, 3)
    assert.equal(trigger.getCall(0).args[0], "click")
    assert.equal(trigger.getCall(0).args[1], 1)
    assert.equal(trigger.getCall(0).args[2].x, 93)
    assert.equal(trigger.getCall(0).args[2].y, 302)

    trigger.restore()
