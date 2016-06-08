#
# User: code house
# Date: 2016/06/07
#
require('./viewTest')
assert = require('assert')
hash = require('object-hash')

ScaleData = require('../../src/Model/scaleData')
AxisData = require('../../src/Model/axisData')
GraphLineData = require('../../src/Model/graphLineData')
GraphPointData = require('../../src/Model/graphPointData')
GraphPoint = require('../../src/Model/graphPoint')
GraphDataCollection = require('../../src/Model/graphDataCollection')
graphCanvasView = require('../../src/View/graphCanvasView')

describe 'GraphCanvasView Class Test', ->
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
    .forEach((point) ->
      lineGraph.addPoint(new GraphPoint(point[0], point[1]))
      pointGraph.addPoint(new GraphPoint(point[0], point[1]))
    )


    collection = new GraphDataCollection([lineGraph, pointGraph]);
    @xScaleData = new ScaleData({title: "X"})
    @yScaleData = new ScaleData({title: "Y"})
    xAxis = new AxisData({max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    yAxis = new AxisData({max:1000, interval:100, subInterval:100, axisColor: "#7bbcd8"})

    @graphCanvas = new graphCanvasView({
      collection: collection
      pos: [0, 0, 400, 600]
      xAxis: xAxis
      yAxis: yAxis
      xScale: @xScaleData
      yScale: @yScaleData
    })
    
  it 'constructor test', ->
    assert.equal(@graphCanvas.pos[0], 0)
    assert.equal(@graphCanvas.pos[1], 0)
    assert.equal(@graphCanvas.pos[2], 400)
    assert.equal(@graphCanvas.pos[3], 600)

    assert.equal(@graphCanvas.$el.prop('tagName'), 'CANVAS')
    assert.equal(@graphCanvas.$wrap.prop('tagName'), 'DIV')
    assert.equal(@graphCanvas.$el.parent()[0], @graphCanvas.$wrap[0])

    assert.equal(@graphCanvas._offsetX, 0)
    assert.equal(@graphCanvas._subView.length, 2)

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

    @graphCanvas.scrollX(-400, false)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-401, false)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(400, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

    @graphCanvas.scrollX(-200, true)
    assert.equal(@graphCanvas.$el.css('left'), '-200px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(0, false)
    assert.equal(@graphCanvas.$el.css('left'), '-200px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(-10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-210px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(-200, false)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(-201, false)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-190px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(200, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(201, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -200)

    @graphCanvas.scrollX(-200, true)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, -400)

    @graphCanvas.scrollX(0, false)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, -400)

    @graphCanvas.scrollX(-1, false)
    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, -400)

    @graphCanvas.scrollX(10, false)
    assert.equal(@graphCanvas.$el.css('left'), '-390px')
    assert.equal(@graphCanvas._offsetX, -400)

    @graphCanvas.scrollX(400, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -400)

    @graphCanvas.scrollX(401, false)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, -400)

    @graphCanvas.scrollX(400, true)
    assert.equal(@graphCanvas.$el.css('left'), '0px')
    assert.equal(@graphCanvas._offsetX, 0)

  it 'function test render()', ->
    expectList = [
      {xScale: 100, width: 400,  hash:"8d62ae66ecc062d827ddbedd6ef1e8b1ee8afc4a"}
      {xScale: 200, width: 800,  hash:"41a4ba6d3ad82fad4421b6b0925edc288322d733"}
      {xScale: 400, width: 1600, hash:"76a5f65713c92551adf4e967711f078b522fab59"}
    ]

    expectList.forEach((expect) =>
      @xScaleData.scale = expect.xScale

      @graphCanvas.render()

      assert.equal(@graphCanvas.$el.css('position'), 'relative')
      assert.equal(@graphCanvas.$el.css('left'), '0px')
      assert.equal(@graphCanvas.$el.css('top'), '0px')
      assert.equal(@graphCanvas.$el.css('width'), "#{expect.width}px")
      assert.equal(@graphCanvas.$el.css('height'), '600px')
      assert.equal(@graphCanvas.$el[0].width, expect.width)
      assert.equal(@graphCanvas.$el[0].height, 600)

      canvas = @graphCanvas.$el[0].getContext('2d')
      imageData = canvas.getImageData(0, 0, expect.width, 600)
      sha1 = hash(imageData.data)

      assert.equal(sha1, expect.hash)
    )

  it 'function test render() after scrollX()', ->
    @xScaleData.scale = 400
    @graphCanvas.scrollX(-1200, true)

    assert.equal(@graphCanvas.$el.css('left'), '-1200px')
    assert.equal(@graphCanvas._offsetX, -1200)

    @xScaleData.scale = 200
    @graphCanvas.render()

    assert.equal(@graphCanvas.$el.css('left'), '-400px')
    assert.equal(@graphCanvas._offsetX, -400)

