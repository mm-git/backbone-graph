#
# User: code house
# Date: 2016/05/31
#
assert = require('assert')
sinon = require('sinon')

ScaleData = require('../../src/Model/scaleData.coffee')

describe 'ScaleData Class Test', ->
  it 'constructor test', ->
    scaleData = new ScaleData({
      title: "X"
    })

    assert.equal(scaleData.title, "X")
    assert.equal(scaleData.scale, 100)

  it 'set properties', ->
    scaleData = new ScaleData({
      title: "X"
    })

    scaleData.scale = 150
    assert.equal(scaleData.scale, 150)

  it 'function test zoomIn()', ->
    scaleData = new ScaleData({
      title: "X"
    })

    testResult = 150
    while testResult < 800
      scaleData.zoomIn()
      assert.equal(scaleData.scale, testResult)
      testResult += 50

    scaleData.zoomIn()
    assert.equal(scaleData.scale, 800)
    scaleData.zoomIn()
    assert.equal(scaleData.scale, 800)

  it 'function test zoomOut()', ->
    scaleData = new ScaleData({
      title: "X"
    })

    scaleData.scale = 800

    testResult = 750
    while testResult > 100
      scaleData.zoomOut()
      assert.equal(scaleData.scale, testResult)
      testResult -= 50

    scaleData.zoomOut()
    assert.equal(scaleData.scale, 100)
    scaleData.zoomOut()
    assert.equal(scaleData.scale, 100)

  it 'adjustInterval test', ->
    scaleData = new ScaleData({
      title: "X"
    })

    [
      [100, 1]
      [150, 1]
      [200, 2]
      [250, 2]
      [300, 2]
      [350, 2]
      [400, 5]
      [450, 5]
      [500, 5]
      [550, 5]
      [600, 5]
      [650, 5]
      [700, 5]
      [750, 5]
      [800, 10]
    ]
    .forEach((range) ->
      scaleData.scale = range[0]
      assert.equal(scaleData.adjustInterval, range[1])
    )
