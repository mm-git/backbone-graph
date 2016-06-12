#
# User: code house
# Date: 2016/06/12
#
assert = require('assert')

GraphLineData = require('../../src/Model/graphLineData.coffee')
GraphPoint = require('../../src/Model/graphPoint.coffee')
ScaleData = require('../../src/Model/scaleData')
AxisData = require('../../src/Model/axisData')
OffsetData = require('../../src/Model/offsetData.coffee')
RangeData = require('../../src/Model/rangeData.coffee')

describe 'RangeData Class Test', ->
  beforeEach ->
    @lineData = new GraphLineData({
      pointColor: "#0000ff"
    })

    @lineData.addPoint(new GraphPoint(0,  100))
    @lineData.addPoint(new GraphPoint(10,  200))
    @lineData.addPoint(new GraphPoint(20,  400))
    @lineData.addPoint(new GraphPoint(30,  350))
    @lineData.addPoint(new GraphPoint(40,  500))
    @lineData.addPoint(new GraphPoint(50,  600))
    @lineData.addPoint(new GraphPoint(60,  550))
    @lineData.addPoint(new GraphPoint(70,  1000))
    @lineData.addPoint(new GraphPoint(80,  200))
    @lineData.addPoint(new GraphPoint(90,  50))
    @lineData.addPoint(new GraphPoint(100, 300))

    @lineData.smooth(1, 5)
    @lineData.calculatePeak(1000, 0.01)
    @lineData.calculateTotalGainAndDrop()

    @xScaleData = new ScaleData({title: "X"})
    @xAxis = new AxisData({max:100,  interval:50,  subInterval:10,  axisColor: "#7bbcd8"})
    @xOffsetData = new OffsetData({
      width: 600
      scale: @xScaleData
    })
    @rangeData = new RangeData({
      width: 600      
      scale: @xScaleData
      axis: @xAxis
      offset: @xOffsetData
      targetGraph: @lineData
      rangeColor: "#7bbcd8"
      rangeOpacity: 0.5
    })

  it 'constructor test', ->
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 0)
    assert.equal(@rangeData.selected, false)
    assert.equal(@rangeData.rangeColor, "#7bbcd8")
    assert.equal(@rangeData.rangeOpacity, 0.5)

  it 'function test autoautoSelect() scale=100', ->
    @rangeData.autoSelect(0)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(600)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(580)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(394)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(395)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(0)
    @rangeData.autoSelect(516)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(517)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

  it 'function test autoautoSelect() scale=400', ->
    @xScaleData.scale = 400

    @rangeData.autoSelect(0)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(2400)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(2380)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(1618)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(1619)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(0)
    @rangeData.autoSelect(2118)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(2119)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

  it 'function test autoautoSelect() scale=400 offset=-400', ->
    @xScaleData.scale = 400
    @xOffsetData.scroll(-400, true)

    @rangeData.autoSelect(-400)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(0)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(2000)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(1980)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(1218)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(1219)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(0)
    @rangeData.autoSelect(1718)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelect(1719)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

