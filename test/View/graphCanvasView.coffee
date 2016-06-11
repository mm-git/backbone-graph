#
# User: code house
# Date: 2016/06/07
#
require('./viewTest')
assert = require('assert')
fs = require('fs')
canvasUtility = require('./canvasUtility')

ScaleData = require('../../src/Model/scaleData')
AxisData = require('../../src/Model/axisData')
GraphLineData = require('../../src/Model/graphLineData')
GraphPointData = require('../../src/Model/graphPointData')
GraphPoint = require('../../src/Model/graphPoint')
GraphDataCollection = require('../../src/Model/graphDataCollection')
graphCanvasView = require('../../src/View/graphCanvasView')

describe 'GraphCanvasView/GraphLineView/GraphPointView Class Test', ->
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

    collection = new GraphDataCollection([lineGraph, pointGraph]);
    @xScaleData = new ScaleData({title: "X"})
    @yScaleData = new ScaleData({title: "Y"})
    @xAxis = new AxisData({max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    @yAxis = new AxisData({max:1000, interval:100, subInterval:100, axisColor: "#7bbcd8"})

    @graphCanvas = new graphCanvasView({
      collection: collection
      pos: [0, 0, 600, 400]
      xAxis: @xAxis
      yAxis: @yAxis
      xScale: @xScaleData
      yScale: @yScaleData
    })
    
  it 'constructor test', ->
    assert.equal(@graphCanvas.pos[0], 0)
    assert.equal(@graphCanvas.pos[1], 0)
    assert.equal(@graphCanvas.pos[2], 600)
    assert.equal(@graphCanvas.pos[3], 400)
    assert.equal(@graphCanvas.xAxis, @xAxis)
    assert.equal(@graphCanvas.yAxis, @yAxis)
    assert.equal(@graphCanvas.xScale, @xScaleData)
    assert.equal(@graphCanvas.yScale, @yScaleData)

    assert.equal(@graphCanvas.$el.prop('tagName'), 'CANVAS')
    assert.equal(@graphCanvas.$wrap.prop('tagName'), 'DIV')
    assert.equal(@graphCanvas.$el.parent()[0], @graphCanvas.$wrap[0])

    assert.equal(@graphCanvas._offsetX, 0)

    assert.equal(@graphCanvas._subView.length, 2)
    assert.equal(@graphCanvas._subView[0].xAxis, @xAxis)
    assert.equal(@graphCanvas._subView[0].yAxis, @yAxis)
    assert.equal(@graphCanvas._subView[1].xAxis, @xAxis)
    assert.equal(@graphCanvas._subView[1].yAxis, @yAxis)

  it 'function test scroolX()', ->
    # canvas can not scroll now,
    # because div width and canvas width is same
    @graphCanvas.scrollX(-10, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-10, true)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(10, true)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    # canvas can scroll
    @xScaleData.scale = 200

    @graphCanvas.scrollX(0, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-10px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-600, false)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-601, false)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(600, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-300, true)
    assert.equal(@graphCanvas.$el.css('left'), '-300px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(0, false)
    assert.equal(@graphCanvas.$el.css('left'), '-300px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(-10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-310px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(-300, false)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(-301, false)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-290px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(300, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(301, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -300)

    @graphCanvas.scrollX(-300, true)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, -600)

    @graphCanvas.scrollX(0, false)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, -600)

    @graphCanvas.scrollX(-1, false)
    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, -600)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-590px')
    assert.equal(@graphCanvas._offsetX, -600)

    @graphCanvas.scrollX(600, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -600)

    @graphCanvas.scrollX(601, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -600)

    @graphCanvas.scrollX(600, true)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

  it 'function test render()', ->
    expectList = [
      {xScale: 100, width: 600}
      {xScale: 200, width: 1200}
      {xScale: 400, width: 2400}
    ]

    try
      fs.mkdirSync('./test/result')
    catch e

    expectList.forEach((expect) =>
      @xScaleData.scale = expect.xScale

      @graphCanvas.render()

      assert.equal(@graphCanvas.$el.css('position'), 'relative')
      assert.equal(@graphCanvas.$el.css('left'), '0px')
      assert.equal(@graphCanvas.$el.css('top'), '0px')
      assert.equal(@graphCanvas.$el.css('width'), "#{expect.width}px")
      assert.equal(@graphCanvas.$el.css('height'), '400px')
      assert.equal(@graphCanvas.$el[0].width, expect.width)
      assert.equal(@graphCanvas.$el[0].height, 400)

      #canvasUtility.save(@graphCanvas.$el[0], "./test/expect/graphCanvas_#{expect.width}.png")

      canvasUtility.save(@graphCanvas.$el[0], "./test/result/graphCanvas_#{expect.width}.png")
    )

  it 'function test render() after scrollX()', ->
    @xScaleData.scale = 400
    @graphCanvas.scrollX(-1800, true)

    assert.equal(@graphCanvas.$el.css('left'), '-1800px')
    assert.equal(@graphCanvas._offsetX, -1800)

    @xScaleData.scale = 200
    @graphCanvas.render()

    assert.equal(@graphCanvas.$el.css('left'), '-600px')
    assert.equal(@graphCanvas._offsetX, -600)

