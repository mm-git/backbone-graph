__ = require('underscore')
GraphData = require('./graphData')

class GraphPointData extends GraphData
  # options = {pointColor: "#RRGGBB"}
  initialize: (options) ->
    super(options)
    @set('type', GraphData.TYPE.POINT)

  @property "pointColor",
    get: ->
      @get('pointColor')

module.exports = GraphPointData
