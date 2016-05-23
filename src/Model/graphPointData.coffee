__ = require('underscore')
GraphData = require('./graphData.coffee')

class GraphPointData extends GraphData
  _pointDataOption = ['_pointColor']

  initialize: (options) ->
    super(options)
    __.extend(@, __.pick(options, _pointDataOption))

    @_type = GraphData.TYPE.POINT

  @property "pointColor",
    get: ->
      @_pointColor

module.exports = GraphPointData
