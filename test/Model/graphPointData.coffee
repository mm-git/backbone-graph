#
# User: code house
# Date: 2016/05/24
#
assert = require('assert')

GraphPointData = require('../../src/Model/graphPointData.coffee')
GraphPoint = require('../../src/Model/graphPoint.coffee')

describe 'GraphPointData Class Test', ->
  it 'constructor test', ->
    pointData = new GraphPointData({
      pointColor: "#0000ff"
    })

    assert.equal(pointData.pointColor, "#0000ff")
    assert.equal(pointData.type, 1)
    assert.equal(pointData.pointList.length, 0)
    assert.equal(pointData.min.x, 0)
    assert.equal(pointData.min.y, 0)
    assert.equal(pointData.max.x, 0)
    assert.equal(pointData.max.y, 0)
    assert.equal(pointData.xMax, 0)

  it 'function test addPoint()', ->
    pointData = new GraphPointData({
      pointColor: "#0000ff"
    })

    pointData.addPoint(new GraphPoint(0, 10))
    assert.equal(pointData.pointList.length, 1)
    assert.equal(pointData.pointList[0].x, 0)
    assert.equal(pointData.pointList[0].y, 10)
    assert.equal(pointData.min.x, 0)
    assert.equal(pointData.min.y, 10)
    assert.equal(pointData.max.x, 0)
    assert.equal(pointData.max.y, 10)
    assert.equal(pointData.xMax, 0)

    pointData.addPoint(new GraphPoint(10, 20))
    assert.equal(pointData.pointList.length, 2)
    assert.equal(pointData.pointList[0].x, 0)
    assert.equal(pointData.pointList[0].y, 10)
    assert.equal(pointData.pointList[1].x, 10)
    assert.equal(pointData.pointList[1].y, 20)
    assert.equal(pointData.min.x, 0)
    assert.equal(pointData.min.y, 10)
    assert.equal(pointData.max.x, 10)
    assert.equal(pointData.max.y, 20)
    assert.equal(pointData.xMax, 10)

    pointData.addPoint(new GraphPoint(20, 5))
    assert.equal(pointData.pointList.length, 3)
    assert.equal(pointData.pointList[0].x, 0)
    assert.equal(pointData.pointList[0].y, 10)
    assert.equal(pointData.pointList[1].x, 10)
    assert.equal(pointData.pointList[1].y, 20)
    assert.equal(pointData.pointList[2].x, 20)
    assert.equal(pointData.pointList[2].y, 5)
    assert.equal(pointData.min.x, 20)
    assert.equal(pointData.min.y, 5)
    assert.equal(pointData.max.x, 10)
    assert.equal(pointData.max.y, 20)
    assert.equal(pointData.xMax, 20)
        
  it 'function test clear()', ->
    pointData = new GraphPointData({
      pointColor: "#0000ff"
    })

    pointData.addPoint(new GraphPoint(0, 10))
    pointData.addPoint(new GraphPoint(10, 20))
    assert.equal(pointData.pointList.length, 2)

    pointData.clear()
    assert.equal(pointData.pointList.length, 0)
    assert.equal(pointData.min.x, 0)
    assert.equal(pointData.min.y, 0)
    assert.equal(pointData.max.x, 0)
    assert.equal(pointData.max.y, 0)
    assert.equal(pointData.xMax, 0)
    