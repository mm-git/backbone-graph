#
# User: code house
# Date: 2016/05/25
#
assert = require('assert')
sinon = require('sinon')

GraphLineData = require('../../src/Model/graphLineData.coffee')
GraphPoint = require('../../src/Model/graphPoint.coffee')

createTestData = ->
  pointData = new GraphLineData({
    lineColor: "#00ff00"
    peakColor: "#ff0000"
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

  return pointData

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
    assert.equal(pointData.isSmooth, false)
    assert.deepEqual(pointData.smoothStatistics, {})
    assert.equal(pointData.isRangeSelected, false)
    assert.equal(pointData.rangeStatistics.start, 0)
    assert.equal(pointData.rangeStatistics.end, 0)

  it 'function test addPoint()', ->
    pointData = new GraphLineData({
      lineColor: "#00ff00"
      peakColor: "#ff0000"
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
      lineColor: "#00ff00"
      peakColor: "#ff0000"
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
    assert.equal(pointData.isSmooth, false)
    assert.deepEqual(pointData.smoothStatistics, {})
    assert.equal(pointData.isRangeSelected, false)
    assert.equal(pointData.rangeStatistics.start, 0)
    assert.equal(pointData.rangeStatistics.end, 0)

  it 'function test smooth()', ->
    pointData = createTestData()

    pointData.smooth(1, 5, 1000, 0.01)
    assert.equal(pointData.pointList.length, 101)
    assert.equal(pointData.min.x, 90)
    assert.equal(pointData.min.y, 50)
    assert.equal(pointData.max.x, 70)
    assert.equal(pointData.max.y, 1000)
    assert.equal(pointData.xMax, 100)

    assert.equal(pointData.peakList.length, 4)
    assert.equal(pointData.peakList[0].index, 0)
    assert.equal(pointData.peakList[0].isMax, false)
    assert.equal(pointData.peakList[1].index, 68)
    assert.equal(pointData.peakList[1].isMax, true)
    assert.equal(pointData.peakList[2].index, 89)
    assert.equal(pointData.peakList[2].isMax, false)
    assert.equal(pointData.peakList[3].index, 100)
    assert.equal(pointData.peakList[3].isMax, true)

    assert.equal(pointData.isSmooth, true)
    assert.equal(Math.floor(pointData.smoothStatistics.min.x), 89)
    assert.equal(Math.floor(pointData.smoothStatistics.min.y), 101)
    assert.equal(Math.floor(pointData.smoothStatistics.max.x), 68)
    assert.equal(Math.floor(pointData.smoothStatistics.max.y), 841)
    assert.equal(Math.floor(pointData.smoothStatistics.gain), 852)
    assert.equal(Math.floor(pointData.smoothStatistics.drop), 740)
    assert.equal(pointData.smoothStatistics.incline.max.incline.toFixed(3), "4.045")
    assert.equal(pointData.smoothStatistics.incline.max.point.x, 64)
    assert.equal(pointData.smoothStatistics.incline.min.incline.toFixed(3), "-7.409")
    assert.equal(pointData.smoothStatistics.incline.min.point.x, 75)
    assert.equal(pointData.smoothStatistics.incline.ave.toFixed(3), "0.112")

  it 'function test unsmooth()', ->
    pointData = createTestData()
    pointData.smooth(1, 5, 1000, 0.01)
    pointData.unsmooth()

    assert.equal(pointData.pointList.length, 11)
    assert.equal(pointData.peakList.length, 0)
    assert.equal(pointData.min.x, 90)
    assert.equal(pointData.min.y, 50)
    assert.equal(pointData.max.x, 70)
    assert.equal(pointData.max.y, 1000)
    assert.equal(pointData.xMax, 100)

    assert.equal(pointData.isSmooth, false)
    assert.deepEqual(pointData.smoothStatistics, {})
    assert.equal(pointData.isRangeSelected, false)
    assert.equal(pointData.rangeStatistics.start, 0)
    assert.equal(pointData.rangeStatistics.end, 0)

  it 'function test getAutoRange()', ->
    pointData = createTestData()
    pointData.smooth(1, 5, 1000, 0.01)

    result = pointData.getAutoRange(0)
    assert.equal(result.start, 0)
    assert.equal(result.end, 68)

    result = pointData.getAutoRange(67)
    assert.equal(result.start, 0)
    assert.equal(result.end, 68)

    result = pointData.getAutoRange(68)
    assert.equal(result.start, 68)
    assert.equal(result.end, 89)

    result = pointData.getAutoRange(88)
    assert.equal(result.start, 68)
    assert.equal(result.end, 89)

    result = pointData.getAutoRange(89)
    assert.equal(result.start, 89)
    assert.equal(result.end, 100)

    result = pointData.getAutoRange(99)
    assert.equal(result.start, 89)
    assert.equal(result.end, 100)

    result = pointData.getAutoRange(100)
    assert.equal(result.start, 89)
    assert.equal(result.end, 100)

  it 'function test setRange()', ->
    pointData = createTestData()
    pointData.smooth(1, 5, 1000, 0.01)

    pointData.setRange({start:0, end:100, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 0)
    assert.equal(pointData.rangeStatistics.end, 100)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 100)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 89)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 101)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 68)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 841)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 852)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 740)
    assert.equal(pointData.rangeStatistics.incline.max.incline.toFixed(3), "4.045")
    assert.equal(pointData.rangeStatistics.incline.max.point.x, 64)
    assert.equal(pointData.rangeStatistics.incline.min.incline.toFixed(3), "-7.409")
    assert.equal(pointData.rangeStatistics.incline.min.point.x, 75)
    assert.equal(pointData.rangeStatistics.incline.ave.toFixed(3), "0.112")

    pointData.setRange({start:0, end:0, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 0)
    assert.equal(pointData.rangeStatistics.end, 0)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 125)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 125)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 0)
    assert.equal(pointData.rangeStatistics.incline, undefined)

    pointData.setRange({start:0.5, end:1.5, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 1)
    assert.equal(pointData.rangeStatistics.end, 1)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 1)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 130)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 1)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 130)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 0)
    assert.equal(pointData.rangeStatistics.incline, undefined)

    pointData.setRange({start:0, end:68, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 0)
    assert.equal(pointData.rangeStatistics.end, 68)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 68)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 125)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 68)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 841)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 716)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 0)
    assert.equal(pointData.rangeStatistics.incline.max.incline.toFixed(3), "4.045")
    assert.equal(pointData.rangeStatistics.incline.max.point.x, 64)
    assert.equal(pointData.rangeStatistics.incline.min.incline.toFixed(3), "-0.364")
    assert.equal(pointData.rangeStatistics.incline.min.point.x, 54)
    assert.equal(pointData.rangeStatistics.incline.ave.toFixed(3), "1.054")

    pointData.setRange({start:68, end:89, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 68)
    assert.equal(pointData.rangeStatistics.end, 89)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 21)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 89)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 101)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 68)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 841)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 740)
    assert.equal(pointData.rangeStatistics.incline.max.incline.toFixed(3), "-0.045")
    assert.equal(pointData.rangeStatistics.incline.max.point.x, 88)
    assert.equal(pointData.rangeStatistics.incline.min.incline.toFixed(3), "-7.409")
    assert.equal(pointData.rangeStatistics.incline.min.point.x, 75)
    assert.equal(pointData.rangeStatistics.incline.ave.toFixed(3), "-3.526")

    pointData.setRange({start:58, end:76, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 58)
    assert.equal(pointData.rangeStatistics.end, 76)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 18)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 76)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 525)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 68)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 841)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 254)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 315)
    assert.equal(pointData.rangeStatistics.incline.max.incline.toFixed(3), "4.045")
    assert.equal(pointData.rangeStatistics.incline.max.point.x, 64)
    assert.equal(pointData.rangeStatistics.incline.min.incline.toFixed(3), "-7.409")
    assert.equal(pointData.rangeStatistics.incline.min.point.x, 75)
    assert.equal(pointData.rangeStatistics.incline.ave.toFixed(3), "-0.341")

    pointData.setRange({start:3, end:4, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 3)
    assert.equal(pointData.rangeStatistics.end, 4)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 1)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 3)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 140)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 4)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 145)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 5)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 0)
    assert.equal(pointData.rangeStatistics.incline.max.incline.toFixed(3), "0.500")
    assert.equal(pointData.rangeStatistics.incline.max.point.x, 3)
    assert.equal(pointData.rangeStatistics.incline.min.incline.toFixed(3), "0.500")
    assert.equal(pointData.rangeStatistics.incline.min.point.x, 3)
    assert.equal(pointData.rangeStatistics.incline.ave.toFixed(3), "0.500")

    pointData.setRange({start:26, end:28, selected:true})
    assert.equal(pointData.isRangeSelected, true)
    assert.equal(pointData.rangeStatistics.start, 26)
    assert.equal(pointData.rangeStatistics.end, 28)
    assert.equal(Math.floor(pointData.rangeStatistics.width), 2)
    assert.equal(Math.floor(pointData.rangeStatistics.min.x), 28)
    assert.equal(Math.floor(pointData.rangeStatistics.min.y), 370)
    assert.equal(Math.floor(pointData.rangeStatistics.max.x), 26)
    assert.equal(Math.floor(pointData.rangeStatistics.max.y), 371)
    assert.equal(Math.floor(pointData.rangeStatistics.gain), 0)
    assert.equal(Math.floor(pointData.rangeStatistics.drop), 0)
    assert.equal(pointData.rangeStatistics.incline.max.incline.toFixed(3), "0.045")
    assert.equal(pointData.rangeStatistics.incline.max.point.x, 27)
    assert.equal(pointData.rangeStatistics.incline.min.incline.toFixed(3), "-0.136")
    assert.equal(pointData.rangeStatistics.incline.min.point.x, 26)
    assert.equal(pointData.rangeStatistics.incline.ave.toFixed(3), "-0.045")

  it 'function test setRange() event', ->
    pointData = createTestData()
    pointData.smooth(1, 5, 1000, 0.01)

    trigger = sinon.spy pointData, 'trigger'

    pointData.setRange({start:0, end:100, selected:true})

    assert.equal(trigger.calledOnce, true)
    assert.equal(trigger.getCall(0).args.length, 1)
    assert.equal(trigger.getCall(0).args[0], "changeSelection")

    trigger.restore()
