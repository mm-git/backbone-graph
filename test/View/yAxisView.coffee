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
YAxisView = require('../../src/View/yAxisView')

describe 'YAxisView Class Test', ->
  beforeEach ->
    @yScaleData = new ScaleData({title: "Y"})
    @yAxis = new AxisData({max:1000, interval:100, subInterval:100, axisColor: "#7bbcd8"})

    @yAxisView = new YAxisView({
      model: @yAxis
      pos: [0, 0, 40, 400]
      yScale: @yScaleData
    })
    
  it 'constructor test', ->
    assert.equal(@yAxisView.pos[0], 0)
    assert.equal(@yAxisView.pos[1], 0)
    assert.equal(@yAxisView.pos[2], 40)
    assert.equal(@yAxisView.pos[3], 400)
    assert.equal(@yAxisView.yScale, @yScaleData)

    assert.equal(@yAxisView.$el.prop('tagName'), 'CANVAS')
    assert.equal(@yAxisView.$wrap.prop('tagName'), 'DIV')
    assert.equal(@yAxisView.$el.parent()[0], @yAxisView.$wrap[0])

  it 'function test render()', ->
    expectList = [
      {yScale: 100, height: 400}
    ]

    try
      fs.mkdirSync('./test/result')
    catch e

    expectList.forEach((expect) =>
      @yScaleData.scale = expect.yScale

      @yAxisView.render()

      assert.equal(@yAxisView.$el.css('position'), 'relative')
      assert.equal(@yAxisView.$el.css('left'), '0px')
      assert.equal(@yAxisView.$el.css('top'), '0px')
      assert.equal(@yAxisView.$el.css('width'), '40px')
      assert.equal(@yAxisView.$el.css('height'), "#{expect.height}px")
      assert.equal(@yAxisView.$el[0].width, 40)
      assert.equal(@yAxisView.$el[0].height, expect.height)

      #canvasUtility.save(@yAxisView.$el[0], "./test/expect/yAxis_#{expect.height}.png")

      canvasUtility.save(@yAxisView.$el[0], "./test/result/yAxis_#{expect.height}.png")
    )
