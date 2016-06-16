Backbone = require('backbone')
GestureData = require('./gestureData')

class GestureDataCollection extends Backbone.Collection
  @REPEAT_INTERVAL : 200

  model: GestureData

  initialize: (options) ->
    @_currentGesture = undefined
    @_repeatMousePos = undefined 
    @_repeatTimer = undefined

  selectCurrentGesture: (x, y) ->
    if @_currentGesture?
      return
    @_currentGesture = @models.slice().reverse().find((model) ->
      model.isInsideActionRegion(x, y)
    )

  deselectCurrentGesture: ->
    @_stopRepeat()
    @_currentGesture = undefined

  getCursor: (x, y) ->
    if @_currentGesture?
      return @_currentGesture.cursor

    targetModel = @models.slice().reverse().find((model) ->
      model.isInsideActionRegion(x, y)
    )
    return targetModel?.cursor || "auto"

  click: (mousePos) ->
    if @_currentGesture?
      @_currentGesture.triggerWithRoundPos("click", mousePos)

  moveStart: (mousePos) ->
    if @_currentGesture?
      @_currentGesture.triggerWithRoundPos("dragStart", mousePos)

      index = @_currentGesture.getInsideRepeatIndex(mousePos.currentPos.x, mousePos.currentPos.y)
      if index >= 0
        @_startRepeat(mousePos, index)
    else
      targetModel = @models.slice().reverse().find((model) ->
        model.isInsideActionRegion(mousePos.currentPos.x, mousePos.currentPos.y)
      )
      targetModel?.triggerWithRoundPos("over", mousePos)

  move: (mousePos) ->
    if @_currentGesture?
      @_currentGesture.triggerWithRoundPos("dragging", mousePos)

      index = @_currentGesture.getInsideRepeatIndex(mousePos.currentPos.x, mousePos.currentPos.y)
      if index >= 0
        @_startRepeat(mousePos, index)
      else
        @_stopRepeat()
      
    else
      targetModel = @models.slice().reverse().find((model) ->
        model.isInsideActionRegion(mousePos.currentPos.x, mousePos.currentPos.y)
      )
      targetModel?.triggerWithRoundPos("over", mousePos)

  moveEnd: (mousePos) ->
    if @_currentGesture?
      @_currentGesture.triggerWithRoundPos("dragEnd", mousePos)

  _startRepeat: (mousePos, index) ->
    @_repeatMousePos = mousePos
    if @_repeatTimer?
      return

    @_repeatTimer = setInterval( =>
      @_currentGesture.triggerWithRoundPos("repeat", @_repeatMousePos, index)
    , GestureDataCollection.REPEAT_INTERVAL
    )

  _stopRepeat: ->
    if @_repeatTimer?
      clearInterval(@_repeatTimer)
    @_repeatTimer = undefined

module.exports = GestureDataCollection
