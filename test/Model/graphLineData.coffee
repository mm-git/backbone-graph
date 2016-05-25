#
# User: code house
# Date: 2016/05/25
#
assert = require('assert')

GraphLineData = require('../../src/Model/graphLineData.coffee')
GraphPoint = require('../../src/Model/graphPoint.coffee')

describe 'GraphLineData Class Test', ->
  it 'constructor test', ->
    pointData = new GraphLineData({
      lineColor: "#00ff00"
      peakColor: "#ff0000"
    })

    assert.equal(pointData.lineColor, "#00ff00")
    assert.equal(pointData.peakColor, "#ff0000")
    assert.equal(pointData.type, 0)
    assert.equal(pointData.pointList.length, 0)
    assert.equal(pointData.min.x, 0)
    assert.equal(pointData.min.y, 0)
    assert.equal(pointData.max.x, 0)
    assert.equal(pointData.max.y, 0)
    assert.equal(pointData.xMax, 0)
    assert.equal(pointData.peakList.length, 0)
    assert.equal(pointData.totalGain, 0)
    assert.equal(pointData.totalDrop, 0)

  it 'function test addPoint()', ->
    pointData = new GraphLineData({
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
    pointData = new GraphLineData({
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
    assert.equal(pointData.peakList.length, 0)
    assert.equal(pointData.totalGain, 0)
    assert.equal(pointData.totalDrop, 0)

  it 'function test smoothing()', ->
    pointData = new GraphLineData({
      pointColor: "#0000ff"
    })

    pointData.addPoint(new GraphPoint(0,  100))
    pointData.addPoint(new GraphPoint(1,  200))
    pointData.addPoint(new GraphPoint(2,  150))
    pointData.addPoint(new GraphPoint(3,  250))
    pointData.addPoint(new GraphPoint(4,  200))
    pointData.addPoint(new GraphPoint(5,  300))
    pointData.addPoint(new GraphPoint(6,  250))
    pointData.addPoint(new GraphPoint(7,  350))
    pointData.addPoint(new GraphPoint(8,  300))
    pointData.addPoint(new GraphPoint(9,  200))
    pointData.addPoint(new GraphPoint(10, 50))

    pointData.smoothing(0.1, 10)
    assert.equal(pointData.pointList.length, 101)

    pointData.calculatePeak(1000, 0.01)
    assert.equal(pointData.peakList.length, 3)
    assert.equal(pointData.peakList[0].index, 0)
    assert.equal(pointData.peakList[0].isMax, false)
    assert.equal(pointData.peakList[1].index, 72)
    assert.equal(pointData.peakList[1].isMax, true)
    assert.equal(pointData.peakList[2].index, 100)
    assert.equal(pointData.peakList[2].isMax, false)

    pointData.calculateTotalGainAndDrop()
    assert.equal(Math.floor(pointData.totalGain), 163)
    assert.equal(Math.floor(pointData.totalDrop), 188)
