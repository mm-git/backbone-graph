class GraphPoint
  constructor: (@_x, @_y) ->

  @property "x",
    get: ->
      @_x
    set: (x) ->
      @_x = x

  @property "y",
    get: ->
      @_y
    set: (y) ->
      @_y = y

module.exports = GraphPoint
