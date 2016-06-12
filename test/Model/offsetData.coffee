#
# User: code house
# Date: 2016/06/12
#
assert = require('assert')

ScaleData = require('../../src/Model/ScaleData')
OffsetData = require('../../src/Model/offsetData.coffee')

describe 'OffsetData Class Test', ->
  beforeEach ->
    @scaleData = new ScaleData({title: "X"})
    @offsetData = new OffsetData({
      width: 600
      scale: @scaleData
    })
    
  it 'constructor test', ->
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

  it 'function test scroll', ->
# canvas can not scroll now,
# because div width and canvas width is same
    @offsetData.scroll(-10, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(10, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(-10, true)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(10, true)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    # canvas can scroll
    @scaleData.scale = 200

    @offsetData.scroll(0, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(-10, false)
    assert.equal(@offsetData.offset, -10)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(-600, false)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(-601, false)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(10, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(600, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

    @offsetData.scroll(-300, true)
    assert.equal(@offsetData.offset, -300)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(0, false)
    assert.equal(@offsetData.offset, -300)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(-10, false)
    assert.equal(@offsetData.offset, -310)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(-300, false)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(-301, false)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(10, false)
    assert.equal(@offsetData.offset, -290)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(300, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(301, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, -300)

    @offsetData.scroll(-300, true)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, -600)

    @offsetData.scroll(0, false)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, -600)

    @offsetData.scroll(-1, false)
    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, -600)

    @offsetData.scroll(10, false)
    assert.equal(@offsetData.offset, -590)
    assert.equal(@offsetData._offsetBase, -600)

    @offsetData.scroll(600, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, -600)

    @offsetData.scroll(601, false)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, -600)

    @offsetData.scroll(600, true)
    assert.equal(@offsetData.offset, 0)
    assert.equal(@offsetData._offsetBase, 0)

  it 'function test scroll() after scale changing', ->
    @scaleData.scale = 400
    @offsetData.scroll(-1800, true)

    assert.equal(@offsetData.offset, -1800)
    assert.equal(@offsetData._offsetBase, -1800)

    @scaleData.scale = 200
    @offsetData.scroll(0, true)

    assert.equal(@offsetData.offset, -600)
    assert.equal(@offsetData._offsetBase, -600)

