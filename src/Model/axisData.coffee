require('./property')
Backbone = require('backbone')

class AxisData extends Backbone.Model
  # options = {max: mx, interval:i, subInterval:s, axisColor:"#RRGGBB"}
  initialize: (options) ->
    @_adjustProperty()

  @property "max",
    get: ->
      @get('max')
    set: (max) ->
      if @max < max
        @set('max', max)

  @property "interval",
    get: ->
      @get('interval')
    set: (interval) ->
      @set('interval', interval)
      @_adjustProperty()

  @property "subInterval",
    get: ->
      @get('subInterval')
    set: (subInterval) ->
      @set('subInterval', subInterval)
      @_adjustProperty()

  @property "axisColor",
    get: ->
      @get('axisColor')

  _adjustProperty: ->
    if @interval < @subInterval
      @subInterval = @interval

module.exports = AxisData
