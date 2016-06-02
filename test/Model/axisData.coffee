#
# User: code house
# Date: 2016/05/23
#
assert = require('assert')

AxisData = require('../../src/Model/axisData')

describe 'AxisData Class Test', ->
  it 'constructor test(interval > sub interval)', ->
    axis = new AxisData({max:1000, interval:100, subInterval:50, axisColor: "#ff0000"})

    assert.equal(axis.max, 1000)
    assert.equal(axis.interval, 100)
    assert.equal(axis.subInterval, 50)
    assert.equal(axis.axisColor, "#ff0000")

  it 'constructor test(interval < sub interval)', ->
    axis = new AxisData({max:1000, interval:100, subInterval:200, axisColor: "#ff0000"})

    assert.equal(axis.max, 1000)
    assert.equal(axis.interval, 100)
    assert.equal(axis.subInterval, 100)
    assert.equal(axis.axisColor, "#ff0000")

  it 'set properties', ->
    axis = new AxisData({max:1000, interval:100, subInterval:50, axisColor: "#ff0000"})

    axis.max = 2000
    assert.equal(axis.max, 2000)

    axis.interval = 200
    assert.equal(axis.interval, 200)

    axis.subInterval = 100
    assert.equal(axis.subInterval, 100)

    axis.subInterval = 200
    assert.equal(axis.subInterval, 200)
