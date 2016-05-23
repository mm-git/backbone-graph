Backbone = require('backbone')
require('./property.coffee')

class AxisData extends Backbone.Model
  @EVENT_AXIS_CHANGED: "axisDataChanged"
  @EVENT_AXIS_REDRAW: "axisDataRedraw"

  initialize: (options) ->
    @_xAxis = options._xAxis
    @_yAxis = options._yAxis
    @_xMax = @_xAxis.max
    @_yMax = @_yAxis.max

  @property "xAxis",
    get: ->
      @_xAxis

  @property "yAxis",
    get: ->
      @_yAxis

  @property "xMax",
    get: ->
      @_xMax

  @property "yMax",
    get: ->
      @_yMax

  setMaximum: (xMax, yMax) ->
    if @_xAxis.max < xMax
      @_xMax = xMax
    if @_yAxis.max < yMax
      @_yMax = yMax

    @trigger AxisData.EVENT_AXIS_CHANGED, @
    return

  notifyRedraw: ->
    @trigger AxisData.EVENT_AXIS_REDRAW, @

module.exports = AxisData
