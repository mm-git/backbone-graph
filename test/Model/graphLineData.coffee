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

  it 'function test smooth()', ->
    pointData = new GraphLineData({
      pointColor: "#0000ff"
    })

    pointData.addPoint(new GraphPoint(0,  100))
    pointData.addPoint(new GraphPoint(10,  200))
    pointData.addPoint(new GraphPoint(20,  400))
    pointData.addPoint(new GraphPoint(30,  350))
    pointData.addPoint(new GraphPoint(40,  500))
    pointData.addPoint(new GraphPoint(50,  600))
    pointData.addPoint(new GraphPoint(60,  550))
    pointData.addPoint(new GraphPoint(70,  1000))
    pointData.addPoint(new GraphPoint(80,  200))
    pointData.addPoint(new GraphPoint(90,  50))
    pointData.addPoint(new GraphPoint(100, 300))

    pointData.smooth(1, 5)
    assert.equal(pointData.pointList.length, 101)

    pointData.calculatePeak(1000, 0.01)
    assert.equal(pointData.peakList.length, 4)
    assert.equal(pointData.peakList[0].index, 0)
    assert.equal(pointData.peakList[0].isMax, false)
    assert.equal(pointData.peakList[1].index, 68)
    assert.equal(pointData.peakList[1].isMax, true)
    assert.equal(pointData.peakList[2].index, 89)
    assert.equal(pointData.peakList[2].isMax, false)
    assert.equal(pointData.peakList[3].index, 100)
    assert.equal(pointData.peakList[3].isMax, true)

    pointData.calculateTotalGainAndDrop()
    assert.equal(Math.floor(pointData.totalGain), 852)
    assert.equal(Math.floor(pointData.totalDrop), 740)

  it 'function test unsmooth()', ->
    pointData = new GraphLineData({
      pointColor: "#0000ff"
    })

    pointData.addPoint(new GraphPoint(0,  100))
    pointData.addPoint(new GraphPoint(10,  200))
    pointData.addPoint(new GraphPoint(20,  400))
    pointData.addPoint(new GraphPoint(30,  350))
    pointData.addPoint(new GraphPoint(40,  500))
    pointData.addPoint(new GraphPoint(50,  600))
    pointData.addPoint(new GraphPoint(60,  550))
    pointData.addPoint(new GraphPoint(70,  1000))
    pointData.addPoint(new GraphPoint(80,  200))
    pointData.addPoint(new GraphPoint(90,  50))
    pointData.addPoint(new GraphPoint(100, 300))

    pointData.smooth(1, 5)
    pointData.calculatePeak(1000, 0.01)
    pointData.calculateTotalGainAndDrop()

    pointData.unsmooth()
    assert.equal(pointData.pointList.length, 11)
    assert.equal(pointData.peakList.length, 0)
    assert.equal(Math.floor(pointData.totalGain), 0)
    assert.equal(Math.floor(pointData.totalDrop), 0)
