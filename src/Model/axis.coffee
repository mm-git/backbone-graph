class Axis
  constructor: (@_max, @_interval, @_subInterval) ->
    if @_interval < @_subInterval
      @_subInterval = @_interval

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

  @property "subInterval",
    get: ->
      @_subInterval
    set: (subInterval) ->
      @_subInterval = subInterval


module.exports = Axis
