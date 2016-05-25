#
# User: code house
# Date: 2016/05/25
#
assert = require('assert')
sinon = require('sinon')

AxisData = require('../../src/Model/axisData.coffee')
Axis = require('../../src/Model/axis.coffee')

describe 'AxisData Class Test', ->
  it 'constructor test', ->
    axisData = new AxisData({
      xAxis: new Axis(10, 50, 10)
      yAxis: new Axis(1000, 500, 100)
    })

    assert.equal(axisData.xAxis.max, 10)
    assert.equal(axisData.xAxis.interval, 50)
    assert.equal(axisData.xAxis.subInterval, 10)
    assert.equal(axisData.yAxis.max, 1000)
    assert.equal(axisData.yAxis.interval, 500)
    assert.equal(axisData.yAxis.subInterval, 100)
    assert.equal(axisData.xMax, 10)
    assert.equal(axisData.yMax, 1000)

  it 'function test setMaximum()', ->
    axisData = new AxisData({
      xAxis: new Axis(10, 50, 10)
      yAxis: new Axis(1000, 500, 100)
    })

    trigger = sinon.spy(axisData, 'trigger')

    axisData.setMaximum(100, 1500)

    assert.equal(axisData.xMax, 100)
    assert.equal(axisData.yMax, 1500)
    assert.equal(trigger.calledOnce, true)
    assert.equal(trigger.getCall(0).args[0], "axisDataChanged")
    assert.equal(trigger.getCall(0).args[1], axisData)

    trigger.restore()

  it 'function test notifyRedraw()', ->
    axisData = new AxisData({
      xAxis: new Axis(10, 50, 10)
      yAxis: new Axis(1000, 500, 100)
    })

    trigger = sinon.spy(axisData, 'trigger')

    axisData.notifyRedraw()

    assert.equal(trigger.calledOnce, true)
    assert.equal(trigger.getCall(0).args[0], "axisDataRedraw")
    assert.equal(trigger.getCall(0).args[1], axisData)

    trigger.restore()
