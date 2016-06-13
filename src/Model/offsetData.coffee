require('./property')
Backbone = require('backbone')

class OffsetData extends Backbone.Model
  # options = {width:w, scale:scaleDataObject}
  initialize: (options) ->
    @set('offset', 0)

  @property "offset",
    get: ->
      @get('offset')

  scroll: (offset) ->
    scrollMax = @get('width') * (1 - @get('scale').scale / 100)

    if @offset + offset > 0
      @set('offset', 0)

    else if @offset + offset < scrollMax
      @set('offset', scrollMax)

    else
      @set('offset', @offset + offset)

module.exports = OffsetData