#
# User: code house
# Date: 2016/06/12
#
assert = require('assert')

ScaleData = require('../../src/Model/scaleData')
ScaleData = require('../../src/Model/scaleData')
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

  it 'function test scroll', ->
# canvas can not scroll now,
# because div width and canvas width is same
    @offsetData.scroll(-1)
    assert.equal(@offsetData.offset, 0)

    @offsetData.scroll(1)
    assert.equal(@offsetData.offset, 0)

    # canvas can scroll
    @scaleData.scale = 200

    @offsetData.scroll(0)
    assert.equal(@offsetData.offset, 0)

    @offsetData.scroll(-10)
    assert.equal(@offsetData.offset, -10)

    @offsetData.scroll(-590)
    assert.equal(@offsetData.offset, -600)

    @offsetData.scroll(-1)
    assert.equal(@offsetData.offset, -600)

    @offsetData.scroll(600)
    assert.equal(@offsetData.offset, 0)

    @offsetData.scroll(1)
    assert.equal(@offsetData.offset, 0)

    @offsetData.scroll(-300)
    assert.equal(@offsetData.offset, -300)

    @offsetData.scroll(0)
    assert.equal(@offsetData.offset, -300)

    @offsetData.scroll(-10)
    assert.equal(@offsetData.offset, -310)

    @offsetData.scroll(-300)
    assert.equal(@offsetData.offset, -600)

    @offsetData.scroll(-1)
    assert.equal(@offsetData.offset, -600)

    @offsetData.scroll(300)
    assert.equal(@offsetData.offset, -300)

    @offsetData.scroll(300)
    assert.equal(@offsetData.offset, 0)

    @offsetData.scroll(1)
    assert.equal(@offsetData.offset, 0)

  it 'function test scroll() after scale changing', ->
    @scaleData.scale = 400
    @offsetData.scroll(-1800)

    assert.equal(@offsetData.offset, -1800)

    @scaleData.scale = 200
    @offsetData.scroll(0)

    assert.equal(@offsetData.offset, -600)

