#
# User: code house
# Date: 2016/06/15
#
assert = require('assert')
sinon = require('sinon')

RectRegion = require('../../src/Model/rectRegion.coffee')
GestureData = require('../../src/Model/gestureData.coffee')
GestureDataCollection = require('../../src/Model/gestureDataCollection.coffee')

describe 'GestureDataCollection Class Test', ->
  beforeEach ->
    @gesture1 = new GestureData({
      region: new RectRegion(0, 0, 600, 400)
      cursor: "hand"
      repeat: [
        new RectRegion(0, 0, 100, 400)
        new RectRegion(500, 0, 600, 400)
      ]
    })
    @gesture2 = new GestureData({
      region: new RectRegion(0, 300, 600, 500)
      cursor: "move"
      repeat: []
    })
    @gestureDataCollection = new GestureDataCollection([@gesture1, @gesture2])

  it 'constructor test', ->
    assert.equal(@gestureDataCollection._currentGesture, undefined)
    assert.equal(@gestureDataCollection._repeatMousePos, undefined)
    assert.equal(@gestureDataCollection._repeatTimer, undefined)

  it 'function test selectCurrentGesture()/deselectCurrentGesture()', ->
    @gestureDataCollection.selectCurrentGesture(-1, -1)
    assert.equal(@gestureDataCollection._currentGesture, undefined)

    @gestureDataCollection.selectCurrentGesture(0, 0)
    assert.equal(@gestureDataCollection._currentGesture, @gesture1)

    @gestureDataCollection.deselectCurrentGesture()
    assert.equal(@gestureDataCollection._currentGesture, undefined)

    @gestureDataCollection.selectCurrentGesture(0, 299)
    assert.equal(@gestureDataCollection._currentGesture, @gesture1)

    @gestureDataCollection.deselectCurrentGesture()
    assert.equal(@gestureDataCollection._currentGesture, undefined)

    @gestureDataCollection.selectCurrentGesture(0, 300)
    assert.equal(@gestureDataCollection._currentGesture, @gesture2)
    @gestureDataCollection.selectCurrentGesture(0, 0)
    assert.equal(@gestureDataCollection._currentGesture, @gesture2)

    @gestureDataCollection.deselectCurrentGesture()
    assert.equal(@gestureDataCollection._currentGesture, undefined)

    @gestureDataCollection.selectCurrentGesture(0, 500)
    assert.equal(@gestureDataCollection._currentGesture, @gesture2)

    @gestureDataCollection.deselectCurrentGesture()
    assert.equal(@gestureDataCollection._currentGesture, undefined)

    @gestureDataCollection.selectCurrentGesture(0, 501)
    assert.equal(@gestureDataCollection._currentGesture, undefined)

  it 'function test getCursor()', ->
    assert.equal(@gestureDataCollection.getCursor(-1,-1), "auto")
    assert.equal(@gestureDataCollection.getCursor(0,0),   "hand")
    assert.equal(@gestureDataCollection.getCursor(0,299), "hand")
    assert.equal(@gestureDataCollection.getCursor(0,300), "move")
    assert.equal(@gestureDataCollection.getCursor(0,500), "move")
    assert.equal(@gestureDataCollection.getCursor(0,501), "auto")

    @gestureDataCollection.selectCurrentGesture(0, 300)
    assert.equal(@gestureDataCollection.getCursor(-1,-1), "move")
    assert.equal(@gestureDataCollection.getCursor(0,0),   "move")
    assert.equal(@gestureDataCollection.getCursor(0,299), "move")
    assert.equal(@gestureDataCollection.getCursor(0,300), "move")
    assert.equal(@gestureDataCollection.getCursor(0,500), "move")
    assert.equal(@gestureDataCollection.getCursor(0,501), "move")

  it 'event handler test click()', ->
    trigger = sinon.spy(@gestureDataCollection, "trigger")

    mousePos =
      currentPos:
        x: 10
        y: 20
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.click(mousePos)
    assert.equal(trigger.callCount, 0)

    @gestureDataCollection.selectCurrentGesture(0, 0)
    @gestureDataCollection.click(mousePos)
    assert.equal(trigger.callCount, 1)
    assert.equal(trigger.getCall(0).args.length, 2)
    assert.equal(trigger.getCall(0).args[0], "click")
    assert.equal(trigger.getCall(0).args[1], mousePos)

    trigger.restore()

  it 'event handler test moveStart()', ->
    trigger = sinon.spy(@gestureDataCollection, "trigger")

    mousePos =
      currentPos:
        x: -1
        y: -1
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.moveStart(mousePos)
    assert.equal(trigger.callCount, 0)

    mousePos =
      currentPos:
        x: 0
        y: 0
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.moveStart(mousePos)
    assert.equal(trigger.callCount, 1)
    assert.equal(trigger.getCall(0).args.length, 2)
    assert.equal(trigger.getCall(0).args[0], "over")
    assert.equal(trigger.getCall(0).args[1], mousePos)

    mousePos =
      currentPos:
        x: 10
        y: 10
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.selectCurrentGesture(0, 0)
    @gestureDataCollection.moveStart(mousePos)
    assert.equal(trigger.callCount, 2)
    assert.equal(trigger.getCall(1).args.length, 2)
    assert.equal(trigger.getCall(1).args[0], "dragStart")
    assert.equal(trigger.getCall(1).args[1], mousePos)

    trigger.restore()

  it 'event handler test move', ->
    trigger = sinon.spy(@gestureDataCollection, "trigger")
    clock = sinon.useFakeTimers()

    mousePos =
      currentPos:
        x: -1
        y: -1
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.move(mousePos)
    assert.equal(trigger.callCount, 0)

    mousePos =
      currentPos:
        x: 200
        y: 0
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.move(mousePos)
    assert.equal(trigger.callCount, 1)
    assert.equal(trigger.getCall(0).args.length, 2)
    assert.equal(trigger.getCall(0).args[0], "over")
    assert.equal(trigger.getCall(0).args[1], mousePos)

    @gestureDataCollection.selectCurrentGesture(0, 0)
    @gestureDataCollection.move(mousePos)
    assert.equal(trigger.callCount, 2)
    assert.equal(trigger.getCall(1).args.length, 2)
    assert.equal(trigger.getCall(1).args[0], "dragging")
    assert.equal(trigger.getCall(1).args[1], mousePos)
    assert.equal(@gestureDataCollection._repeatMousePos, undefined)
    assert.equal(@gestureDataCollection._repeatTimer, undefined)

    mousePos =
      currentPos:
        x: 0
        y: 0
      differencePos:
        x: -10
        y: -20

    @gestureDataCollection.move(mousePos)
    assert.equal(trigger.callCount, 3)
    assert.equal(trigger.getCall(2).args.length, 2)
    assert.equal(trigger.getCall(2).args[0], "dragging")
    assert.equal(trigger.getCall(2).args[1], mousePos)
    assert.equal(@gestureDataCollection._repeatMousePos, mousePos)
    assert.notEqual(@gestureDataCollection._repeatTimer, undefined)

    clock.tick(200)

    assert.equal(trigger.callCount, 4)
    assert.equal(trigger.getCall(3).args.length, 3)
    assert.equal(trigger.getCall(3).args[0], "repeat")
    assert.equal(trigger.getCall(3).args[1], mousePos)
    assert.equal(trigger.getCall(3).args[2], 0)

    mousePos =
      currentPos:
        x: 200
        y: 0
      differencePos:
        x: -10
        y: -20

    clock.restore()

    @gestureDataCollection.move(mousePos)
    assert.equal(trigger.callCount, 5)
    assert.equal(trigger.getCall(4).args.length, 2)
    assert.equal(trigger.getCall(4).args[0], "dragging")
    assert.equal(trigger.getCall(4).args[1], mousePos)
    assert.equal(@gestureDataCollection._repeatTimer, undefined)

    trigger.restore()
