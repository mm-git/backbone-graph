#
# User: code house
# Date: 2016/06/15
#
__ = require('underscore')
$ = global.$ || require('jquery')
Backbone = require('backbone')

class GestureView extends Backbone.View
  events: 
    mousedown: "_onMouseDown"
    mousemove: "_onMouseMove"
    mouseup: "_onMouseUp"

  initialize: (options) ->
    @_mouseMoving = false
    @_lastMousePos = null

    __.bindAll(@, "_onMouseDown", "_onMouseMove", "_onMouseUp")
    $(document).on('mousemove', (event) => @_onMouseMove(event))
    $(document).on('mouseup', (event) => @_onMouseUp(event))
    $(document).on('dragend', (event) => @_onMouseUp(event))

  _onMouseDown: (event) ->
    mousePos = @_getMousePos(event)
    @_mouseMoving = false
    @collection.selectCurrentModel(mousePos.currentPos.x, mousePos.currentPos.y)

  _onMouseMove: (event) ->
    mousePos = @_getMousePos(event)
    if @_mouseMoving == false
      @collection.moveStart(mousePos)
      @_mouseMoving = true
    else
      @collection.move(mousePos)
    document.body.style.cursor = @collection.getCursor(mousePos.currentPos.x, mousePos.currentPos.y)

  _onMouseUp: (event) ->
    mousePos = @_getMousePos(event)

    if @_mouseMoving == false
      @collection.click(mousePos)

    @collection.deselectCurrentModel()
    document.body.style.cursor = @collection.getCursor(mousePos.currentPos.x, mousePos.currentPos.y)

  _getMousePos: (event) ->
    currentPos =  @_getCurrentPos(event)
    mousePos =
      currentPos: currentPos
      differencePos: @_getDifference(currentPos)
    @_lastMousePos = currentPos
    return mousePos

  _getCurrentPos: (event) ->
    elementPos = @$el[0].getBoundingClientRect()
    return {
      x : event.pageX - elementPos.left - window.pageXOffset
      y : event.pageY - elementPos.top - window.pageYOffset
    }

  _getDifference: (currentPos) ->
    if @_lastMousePos == null
      return {
        x: 0
        y: 0
      }

    return {
      x: currentPos.x - @_lastMousePos.x
      y: currentPos.y - @_lastMousePos.y
    }


module.exports = GestureView