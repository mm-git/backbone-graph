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

  triggerEvent: (eventName, index, screenPos) ->
    @trigger(eventName, index, screenPos)

    
module.exports = GraphPointData
