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
OffsetData = require('../../src/Model/offsetData.coffee')
XAxisView = require('../../src/View/xAxisView')

describe 'XAxisView Class Test', ->
  beforeEach ->
    @xScaleData = new ScaleData({title: "X"})
    @xAxis = new AxisData({max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    @xOffsetData = new OffsetData({
      width: 600
      scale: @xScaleData
    })

    @xAxisView = new XAxisView({
      model: @xAxis
      pos: [0, 0, 600, 20]
      xScale: @xScaleData
      xOffset: @xOffsetData
    })
    
  it 'constructor test', ->
    assert.equal(@xAxisView.pos[0], 0)
    assert.equal(@xAxisView.pos[1], 0)
    assert.equal(@xAxisView.pos[2], 600)
    assert.equal(@xAxisView.pos[3], 20)
    assert.equal(@xAxisView.xScale, @xScaleData)
    assert.equal(@xAxisView.xOffset, @xOffsetData)

    assert.equal(@xAxisView.$el.prop('tagName'), 'CANVAS')
    assert.equal(@xAxisView.$wrap.prop('tagName'), 'DIV')
    assert.equal(@xAxisView.$el.parent()[0], @xAxisView.$wrap[0])

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

      @xAxisView.render()

      assert.equal(@xAxisView.$el.css('position'), 'relative')
      assert.equal(@xAxisView.$el.css('left'), '0px')
      assert.equal(@xAxisView.$el.css('top'), '0px')
      assert.equal(@xAxisView.$el.css('width'), "#{expect.width}px")
      assert.equal(@xAxisView.$el.css('height'), '20px')
      assert.equal(@xAxisView.$el[0].width, expect.width)
      assert.equal(@xAxisView.$el[0].height, 20)

      #canvasUtility.save(@xAxisView.$el[0], "./test/expect/xAxis_#{expect.width}.png")

      canvasUtility.save(@xAxisView.$el[0], "./test/result/xAxis_#{expect.width}.png")
    )

  it 'function test scrollX()', ->
    @xScaleData.scale = 400
    @xOffsetData.scroll(-1800, true)
    @xAxisView.render()

    assert.equal(@xAxisView.$el.css('left'), '-1800px')

    @xScaleData.scale = 200
    @xOffsetData.scroll(0, true)
    @xAxisView.render()

    assert.equal(@xAxisView.$el.css('left'), '-600px')
