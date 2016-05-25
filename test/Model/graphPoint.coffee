#
# User: code house
# Date: 2016/05/24
#
assert = require('assert')

GraphPoint = require('../../src/Model/graphPoint')

describe 'GraphPoint Class Test', ->
  it 'constructor test', ->
    point = new GraphPoint(10, 20)

    assert.equal(point.x, 10)
    assert.equal(point.y, 20)

  it 'set properties', ->
    point = new GraphPoint(10, 20)

    point.x = 30
    assert.equal(point.x, 30)

    point.y = 40
    assert.equal(point.y, 40)
