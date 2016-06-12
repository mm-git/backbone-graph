#
# User: code house
# Date: 2016/06/07
#
require('./viewTest')
assert = require('assert')

GraphLineData = require('../../src/Model/graphLineData.coffee')
GraphPoint = require('../../src/Model/graphPoint.coffee')
ScaleData = require('../../src/Model/scaleData')
AxisData = require('../../src/Model/axisData')
OffsetData = require('../../src/Model/offsetData')
RangeData = require('../../src/Model/rangeData')
RangeView = require('../../src/View/RangeView')

describe 'RangeView Class Test', ->
  beforeEach ->
    @lineData = new GraphLineData({
      pointColor: "#0000ff"
    })

    @lineData.addPoint(new GraphPoint(0,  100))
    @lineData.addPoint(new GraphPoint(10,  200))
    @lineData.addPoint(new GraphPoint(20,  400))
    @lineData.addPoint(new GraphPoint(30,  350))
    @lineData.addPoint(new GraphPoint(40,  500))
    @lineData.addPoint(new GraphPoint(50,  600))
    @lineData.addPoint(new GraphPoint(60,  550))
    @lineData.addPoint(new GraphPoint(70,  1000))
    @lineData.addPoint(new GraphPoint(80,  200))
    @lineData.addPoint(new GraphPoint(90,  50))
    @lineData.addPoint(new GraphPoint(100, 300))

    @lineData.smooth(1, 5)
    @lineData.calculatePeak(1000, 0.01)
    @lineData.calculateTotalGainAndDrop()

    @xScaleData = new ScaleData({title: "X"})
    @xAxis = new AxisData({max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    @xOffsetData = new OffsetData({
      width: 600
      scale: @xScaleData
    })
    @rangeData = new RangeData({
      width: 600
      scale: @xScaleData
      axis: @xAxis
      offset: @xOffsetData
      targetGraph: @lineData
      rangeColor: "#7bbcd8"
      rangeOpacity: 0.5
    })

    @rangeView = new RangeView({
      model: @rangeData
      pos: [0, 0, 600, 400]
      xAxis: @xAxis
      xScale: @xScaleData
      xOffset: @xOffsetData
    })
    
  it 'constructor test', ->
    assert.equal(@rangeView.pos[0], 0)
    assert.equal(@rangeView.pos[1], 0)
    assert.equal(@rangeView.pos[2], 600)
    assert.equal(@rangeView.pos[3], 400)
    assert.equal(@rangeView.xAxis, @xAxis)
    assert.equal(@rangeView.xScale, @xScaleData)
    assert.equal(@rangeView.xOffset, @xOffsetData)

    assert.equal(@rangeView.$el.prop('tagName'), 'CANVAS')
    assert.equal(@rangeView.$wrap.prop('tagName'), 'DIV')
    assert.equal(@rangeView.$el.parent()[0], @rangeView.$wrap[0])

  it 'function test render()', ->
    expectList = [
      {xScale: 100, width: 600}
      {xScale: 200, width: 1200}
      {xScale: 400, width: 2400}
    ]

    @rangeData.autoSelect(0)
    expectList.forEach((expect) =>
      @xScaleData.scale = expect.xScale
      @rangeView.render()

      assert.equal(@rangeView.$el.css('position'), 'relative')
      assert.equal(@rangeView.$el.css('left'), '0px')
      assert.equal(@rangeView.$el.css('top'), '0px')
      assert.equal(@rangeView.$el.css('width'), "#{expect.width}px")
      assert.equal(@rangeView.$el.css('height'), '400px')
      assert.equal(@rangeView.$el[0].width, expect.width)
      assert.equal(@rangeView.$el[0].height, 400)
    )

  it 'function test scrollX()', ->
    @xScaleData.scale = 400
    @xOffsetData.scroll(-1800, true)
    @rangeView.render()

    assert.equal(@rangeView.$el.css('left'), '-1800px')

    @xScaleData.scale = 200
    @xOffsetData.scroll(0, true)
    @rangeView.render()

    assert.equal(@rangeView.$el.css('left'), '-600px')
