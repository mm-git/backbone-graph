Backbone = require('backbone')

class GraphData extends Backbone.Model
  @TYPE:
    LINE : 0
    POINT : 1

  initialize: (options) ->
    @set('type', GraphData.TYPE.LINE)

    @_pointList = []
    @_min =
      x: 0
      y: 0
    @_max =
      x: 0
      y: 0

  @property "type",
    get: ->
      @get('type')

  @property "pointList",
    get: ->
      @_pointList

  @property "min",
    get: ->
      @_min

  @property "max",
    get: ->
      @_max

  @property "xMax",
    get: ->
      if @_pointList.length == 0
        return 0
      @_pointList[@_pointList.length-1].x

  clear: ->
    @_pointList = []
    @_min =
      x: 0
      y: 0
    @_max =
      x: 0
      y: 0

  addPoint: (point) ->
    @_pointList.push(point)
    if @_pointList.length == 1
      @_min = point
      @_max = point
    else
      if @_min.y > point.y
        @_min = point
      if @_max.y < point.y
        @_max = point

module.exports = GraphData
