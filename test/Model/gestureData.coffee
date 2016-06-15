#
# User: code house
# Date: 2016/06/15
#
assert = require('assert')

RectRegion = require('../../src/Model/rectRegion.coffee')
GestureData = require('../../src/Model/gestureData.coffee')

describe 'GestureData Class Test', ->
  it 'constructor test', ->
    gesture = new GestureData({
      region: new RectRegion(0, 0, 600, 400)
      cursor: "auto"
      repeat: [
        new RectRegion(0, 0, 100, 400)
        new RectRegion(500, 0, 600, 400)
      ]
    })

    assert.equal(gesture.cursor, "auto")

  it 'function test isInsideRegion()', ->
    gesture = new GestureData({
      region: new RectRegion(0, 0, 600, 400)
      cursor: "auto"
      repeat: [
        new RectRegion(0, 0, 100, 400)
        new RectRegion(500, 0, 600, 400)
      ]
    })

    assert.equal(gesture.isInsideRegion(-1, -1), false)
    assert.equal(gesture.isInsideRegion(0, 0), true)
    assert.equal(gesture.isInsideRegion(1, 1), true)
    assert.equal(gesture.isInsideRegion(599, 399), true)
    assert.equal(gesture.isInsideRegion(600, 400), true)
    assert.equal(gesture.isInsideRegion(601, 401), false)

  it 'function test getInsideRepeatIndex()', ->
    gesture = new GestureData({
      region: new RectRegion(0, 0, 600, 400)
      cursor: "auto"
      repeat: [
        new RectRegion(0, 0, 100, 400)
        new RectRegion(500, 0, 600, 400)
      ]
    })

    assert.equal(gesture.getInsideRepeatIndex(-1, 0), -1)
    assert.equal(gesture.getInsideRepeatIndex(0, 0), 0)
    assert.equal(gesture.getInsideRepeatIndex(1, 0), 0)
    assert.equal(gesture.getInsideRepeatIndex(99, 0), 0)
    assert.equal(gesture.getInsideRepeatIndex(100, 0), 0)
    assert.equal(gesture.getInsideRepeatIndex(101, 0), -1)
    assert.equal(gesture.getInsideRepeatIndex(499, 0), -1)
    assert.equal(gesture.getInsideRepeatIndex(500, 0), 1)
    assert.equal(gesture.getInsideRepeatIndex(501, 0), 1)
    assert.equal(gesture.getInsideRepeatIndex(599, 0), 1)
    assert.equal(gesture.getInsideRepeatIndex(600, 0), 1)
    assert.equal(gesture.getInsideRepeatIndex(601, 0), -1)

    assert.equal(gesture.getInsideRepeatIndex(0, -1), -1)
    assert.equal(gesture.getInsideRepeatIndex(0, 0), 0)
    assert.equal(gesture.getInsideRepeatIndex(0, 1), 0)
    assert.equal(gesture.getInsideRepeatIndex(0, 399), 0)
    assert.equal(gesture.getInsideRepeatIndex(0, 400), 0)
    assert.equal(gesture.getInsideRepeatIndex(0, 401), -1)
