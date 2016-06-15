require('./property')

class RectRegion
  constructor: (@_minX, @_minY, @_maxX, @_maxY) ->
    @_checkParameter(@_minX, @_minY, @_maxX, @_maxY)

  @property "minX",
    get: ->
      @_minX
    set: (minX) ->
      @_checkParameter(minX, @_minY, @_maxX, @_maxY)
      @_minX = minX

  @property "minY",
    get: ->
      @_minY
    set: (minY) ->
      @_checkParameter(@_minX, minY, @_maxX, @_maxY)
      @_minY = minY

  @property "maxX",
    get: ->
      @_maxX
    set: (maxX) ->
      @_checkParameter(@_minX, @_minY, maxX, @_maxY)
      @_maxX = maxX

  @property "maxY",
    get: ->
      @_maxY
    set: (maxY) ->
      @_checkParameter(@_minX, @_minY, @_maxX, maxY)
      @_maxY = maxY

  isInside: (x, y) ->
    if @_minX? && x < @_minX
      return false

    if @_maxX? && x > @_maxX
      return false

    if @_minY? && y < @_minY
      return false

    if @_maxY? && y > @_maxY
      return false

    return true

  _checkParameter: (minX, minY, maxX, maxY) ->
    if !minX? && !minY? && !maxX? && !maxY?
      throw "All parameters are null"

    if minX? && maxX? && minX > maxX
      throw "minX muse be less than maxX"

    if minY? && maxY? && minY > maxY
      throw "minY muse be less than maxY"

    return

module.exports = RectRegion