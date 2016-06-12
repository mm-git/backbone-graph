require('./property')
Backbone = require('backbone')

GraphData = require('./graphData')

class RangeData extends Backbone.Model
  # options =
  #   width: w
  #   scale: scaleDataObject
  #   axis: axisDataObject
  #   offset: offsetDataObject
  #   targetGraph: graphLineDataObject
  #   rangeColor: "#RRGGBB"
  #   rangeOpacity: o
  initialize: (options) ->
    @set('start', 0)
    @set('end', 0)
    @set('selected', false)

  @property "start",
    get: ->
      @get('start')

  @property "end",
    get: ->
      @get('end')

  @property "selected",
    get: ->
      @get('selected')

  @property "rangeColor",
    get: ->
      @get('rangeColor')

  @property "rangeOpacity",
    get: ->
      @get('rangeOpacity')

  autoSelect: (offset) ->
    GraphView = require('../View/graphView')

    if @get('targetGraph').type != GraphData.TYPE.LINE
      return

    width = @get('width') * @get('scale').scale / 100 - GraphView.ORIGIN_OFFSET_Y
    clickPos = offset - @get('offset').offset
    if clickPos > width
      return

    x = clickPos * @get('axis').max / width
    range = @get('targetGraph').getAutoRange(x)
    if range == null
      return

    range.selected = true
    @set(range)

module.exports = RangeData