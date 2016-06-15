require('./property')
Backbone = require('backbone')

class GestureData extends Backbone.Model
  # options
  #   region: RectRegion Object
  #   cursor: cursor name string
  #   repeat: [RectRegion Object, ..]
  initialize: (options) ->

  @property "cursor",
    get: ->
      @get('cursor')

  isInsideRegion: (x, y) ->
    return @get('region').isInside(x, y)

  getInsideRepeatIndex: (x, y) ->
    result = -1
    @get('repeat').some((repeatRegion, index) ->
      if repeatRegion.isInside(x,y)
        result = index
        return true
      return false
    )
    return result

module.exports = GestureData