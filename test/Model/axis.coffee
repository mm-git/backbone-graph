#
# User: code house
# Date: 2016/05/23
#
assert = require('assert')

Axis = require('../../src/Model/axis')

describe 'Axis Class Test', ->
  it 'constructor test(interval > sub interval)', ->
    axis = new Axis(1000, 100, 50)

    assert.equal(axis.max, 1000)
    assert.equal(axis.interval, 100)
    assert.equal(axis.subInterval, 50)

  it 'constructor test(interval < sub interval)', ->
    axis = new Axis(1000, 100, 200)

    assert.equal(axis.max, 1000)
    assert.equal(axis.interval, 100)
    assert.equal(axis.subInterval, 100)

  it 'set properties', ->
    axis = new Axis(1000, 100, 50)

    axis.max = 2000
    assert.equal(axis.max, 2000)

    axis.interval = 200
    assert.equal(axis.interval, 200)

    axis.subInterval = 100
    assert.equal(axis.subInterval, 100)

    axis.subInterval = 200
    assert.equal(axis.subInterval, 200)
