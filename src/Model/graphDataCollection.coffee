Backbone = require('backbone')
require('./property')
GraphData = require('./graphData')

class GraphDataCollection extends Backbone.Collection
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
    @trigger("change", @)

module.exports = GraphDataCollection
