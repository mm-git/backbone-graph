require('./property')
Backbone = require('backbone')

class OffsetData extends Backbone.Model
  # options = {width:w, scale:scaleDataObject}
  initialize: (options) ->
    @set('offset', 0)
    @_offsetBase = 0

  @property "offset",
    get: ->
      @get('offset')

  scroll: (offset, refresh) ->
    scrollMax = @get('width') * (1 - @scale.scale / 100)

    if @_offsetBase + offset > 0
      @set('offset', 0)
      if refresh
        @_offsetBase = 0

    else if @_offsetBase + offset < scrollMax
      @set('offset', scrollMax)
      if refresh
        @_offsetBase = scrollMax

    else
      @set('offset', @_offsetBase + offset)
      if refresh
        @_offsetBase += offset

module.exports = OffsetData