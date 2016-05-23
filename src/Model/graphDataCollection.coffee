Backbone = require('backbone')
require('./property.coffee')
GraphData = require('./graphData.coffee')

class GraphDataCollection extends Backbone.Collection
  @EVENT_GRAPHDATA_CHANGED: "graphDataChanged"

  model: GraphData

  @property "xMax",
    get: ->
      Math.max.apply(null, @map((model) ->
        model.xMax
      ))

  @property "yMax",
    get: ->
      Math.max.apply(null, @map((model) ->
        model.max.y
      ))

  change: ->
    @trigger GraphDataCollection.EVENT_GRAPHDATA_CHANGED, @

module.exports = GraphDataCollection
