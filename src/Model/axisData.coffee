Backbone = require('backbone')
require('./property')

class AxisData extends Backbone.Model
  @EVENT_AXIS_CHANGED: "axisDataChanged"
  @EVENT_AXIS_REDRAW: "axisDataRedraw"

  # options = {xAxis: AxisClassObject, yAxis: AxisClassObject}
  initialize: (options) ->
    @_xMax = @get('xAxis').max
    @_yMax = @get('yAxis').max

  @property "xAxis",
    get: ->
      @get('xAxis')

  @property "yAxis",
    get: ->
      @get('yAxis')

  @property "xMax",
    get: ->
      @_xMax
    set: (max) ->
      if @get('xAxis').max > max
        @_xMax = @get('xAxis').max
      else
        @_xMax = max

  @property "yMax",
    get: ->
      @_yMax
    set: (max) ->
      if @get('yAxis').max > max
        @_yMax = @get('yAxis').max
      else
        @_yMax = max

  setMaximum: (xMax, yMax) ->
    @xMax = xMax
    @yMax = yMax

    @trigger AxisData.EVENT_AXIS_CHANGED, @
    return

  notifyRedraw: ->
    @trigger AxisData.EVENT_AXIS_REDRAW, @

module.exports = AxisData
