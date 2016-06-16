require('./property')
Backbone = require('backbone')

class GestureData extends Backbone.Model
  # options
  #   actionRegion: RectRegion Object
  #   roundRegion: RectRegion Object
  #   cursor: cursor name string
  #   repeat: [RectRegion Object, ..]
  initialize: (options) ->

  @property "cursor",
    get: ->
      @get('cursor')

  isInsideActionRegion: (x, y) ->
    return @get('actionRegion').isInside(x, y)

  getInsideRepeatIndex: (x, y) ->
    result = -1
    @get('repeat').some((repeatRegion, index) ->
      if repeatRegion.isInside(x,y)
        result = index
        return true
      return false
    )
    return result

  triggerWithRoundPos: (eventName, mousePos, index) ->
    mousePos.roundPos = @get('roundRegion').getRound(mousePos.currentPos.x, mousePos.currentPos.y)
    @trigger(eventName, mousePos, index)

module.exports = GestureData