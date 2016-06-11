Backbone = require('backbone')

class ScaleNumberView extends Backbone.View
  tagName: "input"
  className: "backbone_graph_scale_number backbone_graph_scale_number_private"

  initialize: (options) ->
    @listenTo(@model, "change", => @render())
    @render()

  render: ->
    @$el
    .attr({
      type: "text"
      readonly: ""
      draggable: false
    })
    .val("#{@model.title} : #{@model.scale}%")

    @

module.exports = ScaleNumberView