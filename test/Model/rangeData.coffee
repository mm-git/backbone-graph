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
    assert.equal(@rangeData.screenStart, 0)
    assert.equal(@rangeData.screenEnd, 0)

  it 'function test autoSelectX() scale=100', ->
    @rangeData.autoSelectX(0)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(600)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(570)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(387)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(389)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(0)
    @rangeData.autoSelectX(507)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(508)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

  it 'function test autoSelectX() scale=400', ->
    @xScaleData.scale = 400

    @rangeData.autoSelectX(0)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(2400)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(2370)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(1611)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(1612)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(0)
    @rangeData.autoSelectX(2109)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(2110)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

  it 'function test autoSelectX() scale=400 offset=-400', ->
    @xScaleData.scale = 400
    @xOffsetData.scroll(-400, true)

    @rangeData.autoSelectX(-400)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(0)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(2000)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(1970)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(1211)
    assert.equal(@rangeData.start, 0)
    assert.equal(@rangeData.end, 68)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(1212)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(0)
    @rangeData.autoSelectX(1709)
    assert.equal(@rangeData.start, 68)
    assert.equal(@rangeData.end, 89)
    assert.equal(@rangeData.selected, true)

    @rangeData.autoSelectX(1710)
    assert.equal(@rangeData.start, 89)
    assert.equal(@rangeData.end, 100)
    assert.equal(@rangeData.selected, true)

  it 'function test selectStartX()/selectEndX()/deselect()', ->
    @rangeData.selectStartX(200)
    assert.equal(Math.floor(@rangeData.start), 35) # 200 * 100 / (600 - 30)
    assert.equal(Math.floor(@rangeData.end), 35)
    assert.equal(@rangeData.selected, true)

    @rangeData.selectEndX(400)
    assert.equal(Math.floor(@rangeData.start), 35)
    assert.equal(Math.floor(@rangeData.end), 70)   # 400 * 100 / (600 - 30)
    assert.equal(@rangeData.selected, true)

    @rangeData.selectEndX(-10)
    assert.equal(Math.floor(@rangeData.end), 0)

    @rangeData.selectEndX(600)
    assert.equal(Math.floor(@rangeData.end), 100)  

    @xScaleData.scale = 400
    @xOffsetData.scroll(-400, true)

    @rangeData.selectStartX(200)
    assert.equal(Math.floor(@rangeData.start), 25) #(200 + 400) * 100 / (600 * 4 -30)
    assert.equal(Math.floor(@rangeData.end), 25)
    assert.equal(@rangeData.selected, true)

    @rangeData.selectEndX(400)
    assert.equal(Math.floor(@rangeData.start), 25)
    assert.equal(Math.floor(@rangeData.end), 33)   #(400 + 400) * 100 / (600 * 4 -30)
    assert.equal(@rangeData.selected, true)

    @rangeData.deselect()
    assert.equal(@rangeData.selected, false)

  it 'parameter test screenStart/screenEnd', ->
    @rangeData.selectStartX(200)
    @rangeData.selectEndX(400)

    assert.equal(@rangeData.screenStart, 200)
    assert.equal(@rangeData.screenEnd, 400)

    @xScaleData.scale = 400
    @xOffsetData.scroll(-400, true)

    assert.equal(Math.floor(@rangeData.screenStart), 431)  # (600 * 4 - 30) * 35.09 / 100 - 400
    assert.equal(Math.floor(@rangeData.screenEnd), 1263)   # (600 * 4 - 30) * 70.18 / 100 - 400
