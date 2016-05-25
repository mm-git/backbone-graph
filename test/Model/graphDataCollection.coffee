#
# User: code house
# Date: 2016/05/25
#
assert = require('assert')
sinon = require('sinon')

GraphDataCollection = require('../../src/Model/graphDataCollection.coffee')
GraphLineData = require('../../src/Model/graphLineData.coffee')
GraphPointData = require('../../src/Model/graphPointData.coffee')
GraphPoint = require('../../src/Model/graphPoint.coffee')


describe 'GraphDataCollection Class Test', ->
  it 'constructor test', ->
    pointData = new GraphPointData({
      pointColor: "#0000ff"
    })

    pointData.addPoint(new GraphPoint(0, 10))
    pointData.addPoint(new GraphPoint(10, 20))
    pointData.addPoint(new GraphPoint(20, 5))

    lineData = new GraphLineData({
      pointColor: "#0000ff"
    })

    lineData.addPoint(new GraphPoint(0,  100))
    lineData.addPoint(new GraphPoint(1,  200))
    lineData.addPoint(new GraphPoint(2,  150))
    lineData.addPoint(new GraphPoint(3,  250))
    lineData.addPoint(new GraphPoint(4,  200))
    lineData.addPoint(new GraphPoint(5,  300))
    lineData.addPoint(new GraphPoint(6,  250))
    lineData.addPoint(new GraphPoint(7,  350))
    lineData.addPoint(new GraphPoint(8,  300))
    lineData.addPoint(new GraphPoint(9,  200))
    lineData.addPoint(new GraphPoint(10, 50))

    graphCollection = new GraphDataCollection([pointData, lineData])

    assert.equal(graphCollection.models.length, 2)
    assert.equal(graphCollection.at(0), pointData)
    assert.equal(graphCollection.at(1), lineData)

    assert.equal(graphCollection.xMax, 20)
    assert.equal(graphCollection.yMax, 350)

  it 'function test change()', ->
    pointData = new GraphPointData({
      pointColor: "#0000ff"
    })
    pointData.addPoint(new GraphPoint(0, 10))

    lineData = new GraphLineData({
      pointColor: "#0000ff"
    })
    lineData.addPoint(new GraphPoint(0,  100))

    graphCollection = new GraphDataCollection([pointData, lineData])

    trigger = sinon.spy graphCollection, 'trigger'

    graphCollection.change()

    assert.equal(trigger.calledOnce, true)
    assert.equal(trigger.getCall(0).args[0], "graphDataChanged")
    assert.equal(trigger.getCall(0).args[1], graphCollection)

    trigger.restore()