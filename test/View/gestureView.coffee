#
# User: code house
# Date: 2016/06/15
#
require('./viewTest')
assert = require('assert')
sinon = require('sinon')

RectRegion = require('../../src/Model/rectRegion.coffee')
GestureData = require('../../src/Model/gestureData.coffee')
GestureDataCollection = require('../../src/Model/gestureDataCollection.coffee')
GestureView = require('../../src/View/gestureView.coffee')

describe 'GestureView Class Test', ->
  beforeEach ->
    @action = ""
    @actionMousePos = undefined
    @gesture1 = new GestureData({
      actionRegion: new RectRegion(0, 0, 600, 400)
      roundRegion: new RectRegion(0, 0, 600, 400)
      cursor: "hand"
      repeat: [
        new RectRegion(0, 0, 100, 400)
        new RectRegion(500, 0, 600, 400)
      ]
    })
    .on({
      click: (mousePos) =>
        @action = "gesture1:click"
        @actionMousePos = mousePos
      over: (mousePos) =>
        @action = "gesture1:over"
        @actionMousePos = mousePos
      dragStart: (mousePos) =>
        @action = "gesture1:dragStart"
        @actionMousePos = mousePos
      dragging: (mousePos) =>
        @action = "gesture1:dragging"
        @actionMousePos = mousePos
      repeat: (mousePos) =>
        @action = "gesture1:repeat"
        @actionMousePos = mousePos
    })
    @gesture2 = new GestureData({
      actionRegion: new RectRegion(0, 300, 600, 500)
      roundRegion: new RectRegion(0, 300, 600, 500)
      cursor: "move"
      repeat: []
    })
    .on({
      click: (mousePos) =>
        @action = "gesture2:click"
        @actionMousePos = mousePos
      over: (mousePos) =>
        @action = "gesture2:over"
        @actionMousePos = mousePos
      dragStart: (mousePos) =>
        @action = "gesture2:dragStart"
        @actionMousePos = mousePos
      dragging: (mousePos) =>
        @action = "gesture2:dragging"
        @actionMousePos = mousePos
    })
    @gestureDataCollection = new GestureDataCollection([@gesture1, @gesture2])

    dummyDim = $('<div>')
    .css({
      left: 0
      top: 0
      width: 600
      height: 400
    })

    @gestureView = new GestureView({
      el: dummyDim
      collection: @gestureDataCollection      
    })
    
  it 'constructor test', ->  
    assert.equal(@gestureView._mouseMoving, false)
    assert.equal(@gestureView._lastMousePos, undefined)

  it 'event test mouse motion', ->
    motions = [
      #action, x, y, mouseMove, currentGesture, action, actionMousePos
      ["mousedown", -1, -1, false, undefined, "", undefined]
      ["mouseup",   -1, -1, false, undefined, "", undefined]
      ["mousedown", 10, 10, false, @gesture1, "", undefined]
      ["mouseup",   10, 10, false, undefined, "gesture1:click", [10,10,0,0]]
      ["mousedown", 10, 10, false, @gesture1, "", undefined]
      ["mousemove", 11, 11, true,  @gesture1, "gesture1:dragStart", [11,11,1,1]]
      ["mousemove", 12, 12, true,  @gesture1, "gesture1:dragging", [12,12,1,1]]
      ["mouseup",   13, 13, true,  undefined, "", undefined]
      ["mousemove", 15, 15, true,  undefined, "gesture1:over", [15,15,2,2]]
      ["mousemove", 16, 16, true,  undefined, "gesture1:over", [16,16,1,1]]
      ["mousedown", 10, 300, false, @gesture2, "", undefined]
      ["mouseup",   10, 300, false, undefined, "gesture2:click", [10,300,0,0]]
      ["mousedown", 10, 300, false, @gesture2, "", undefined]
      ["mousemove", 11, 301, true,  @gesture2, "gesture2:dragStart", [11,301,1,1]]
      ["mousemove", 12, 302, true,  @gesture2, "gesture2:dragging", [12,302,1,1]]
      ["mousemove", 10, 10,  true,  @gesture2, "gesture2:dragging", [10,10,-2,-292]]
      ["mouseup",   10, 10,  true,  undefined, "", undefined]
      ["mousemove", 15, 300, true,  undefined, "gesture2:over", [15,300,5,290]]
      ["mousemove", 16, 301, true,  undefined, "gesture2:over", [16,301,1,1]]
    ]

    motions.forEach((motion) =>
      event = $.Event(motion[0], {pageX: motion[1], pageY: motion[2]})
      @gestureView.$el.trigger(event)

      assert.equal(@gestureView._mouseMoving, motion[3])
      assert.equal(@gestureView.collection._currentGesture, motion[4])
      assert.equal(@action, motion[5])
      if motion[6] == undefined
        assert.equal(@actionMousePos, motion[6])
      else
        assert.equal(@actionMousePos.currentPos.x, motion[6][0])
        assert.equal(@actionMousePos.currentPos.y, motion[6][1])
        assert.equal(@actionMousePos.differencePos.x, motion[6][2])
        assert.equal(@actionMousePos.differencePos.y, motion[6][3])

      @action = ""
      @actionMousePos = undefined
    )

  it 'event test mouse motion(repeat)', ->
    clock = sinon.useFakeTimers()

    event = $.Event("mousedown", {pageX: 0, pageY: 0})
    @gestureView.$el.trigger(event)
    event = $.Event("mousemove", {pageX: 1, pageY: 1})
    @gestureView.$el.trigger(event)

    clock.tick(200)

    assert.equal(@gestureView._mouseMoving, true)
    assert.equal(@gestureView.collection._currentGesture, @gesture1)
    assert.equal(@action, "gesture1:repeat")
    assert.equal(@actionMousePos.currentPos.x, 1)
    assert.equal(@actionMousePos.currentPos.y, 1)
    assert.equal(@actionMousePos.differencePos.x, 1)
    assert.equal(@actionMousePos.differencePos.y, 1)

    @action = ""
    @actionMousePos = undefined

    clock.tick(200)

    assert.equal(@action, "gesture1:repeat")
    assert.equal(@actionMousePos.currentPos.x, 1)
    assert.equal(@actionMousePos.currentPos.y, 1)
    assert.equal(@actionMousePos.differencePos.x, 1)
    assert.equal(@actionMousePos.differencePos.y, 1)

    clock.restore()