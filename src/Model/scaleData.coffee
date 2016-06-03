Backbone = require('backbone')
require('./property')

class ScaleData extends Backbone.Model
  initialize: (options) ->
    @set('scale', 100)

  @property "title",
    get: ->
      @get('title')

  @property "scale",
    get: ->
      @get('scale')
    set: (value) ->
      @set('scale', value)

  @property "adjustInterval",
    get: ->
      result = 1
      [[200, 2], [400, 5], [800, 10]]
      .some((range) =>
        if @scale < range[0]
          return true
        result = range[1]
        return false
      )
      return result

  zoomOut: ->
    if @scale <= 100
      return
    @scale -= 50

  zoomIn: ->
    if @scale >= 800
      return
    @scale += 50

module.exports = ScaleData


