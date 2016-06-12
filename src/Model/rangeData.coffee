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

  autoSelectX: (offset) ->
    if @get('targetGraph').type != GraphData.TYPE.LINE
      return null

    graphX = @_getGraphX(offset)
    if graphX.rangeOver == true
      return

    range = @get('targetGraph').getAutoRange(graphX.x)
    if range == null
      return

    range.selected = true
    @set(range)

  selectStartX: (offset) ->
    if @get('targetGraph').type != GraphData.TYPE.LINE
      return null

    graphX = @_getGraphX(offset)
    if graphX.rangeOver == true
      return

    @set({
      start: graphX.x
      end: graphX.x
      selected: true
    })

  selectEndX: (offset) ->
    if @get('targetGraph').type != GraphData.TYPE.LINE
      return null

    graphX = @_getGraphX(offset)
    @set({end: graphX.x})

  _getGraphX: (offset) ->
    GraphView = require('../View/graphView')

    width = @get('width') * @get('scale').scale / 100 - GraphView.ORIGIN_OFFSET_Y
    clickPos = offset - @get('offset').offset
    if clickPos > width
      return {
        x : @get('axis').max
        rangeOver: true
      }
    else if clickPos < 0
      return {
        x : 0
        rangeOver: true
      }

    return {
      x: clickPos * @get('axis').max / width
      rangeOver: false
    }



module.exports = RangeData