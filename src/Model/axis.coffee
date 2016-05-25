require('./property')

class Axis
  constructor: (@_max, @_interval, @_subInterval) ->
    @_adjustProperty()

  @property "max",
    get: ->
      @_max
    set: (max) ->
      @_max = max

  @property "interval",
    get: ->
      @_interval
    set: (interval) ->
      @_interval = interval
      @_adjustProperty()

  @property "subInterval",
    get: ->
      @_subInterval
    set: (subInterval) ->
      @_subInterval = subInterval
      @_adjustProperty()

  _adjustProperty: ->
    if @_interval < @_subInterval
      @_subInterval = @_interval



module.exports = Axis
