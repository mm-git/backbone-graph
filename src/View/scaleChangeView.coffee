__ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')
ScaleButtonView = require('./scaleButtonView')
ScaleNumberView = require('./scaleNumberView')

class ScaleChangeView extends Backbone.View
  tagName: "div"
  className: "backbone_graph_scale backbone_graph_scale_private"

  initialize: (options) ->
    @render()

  render: ->
    @$el.append(new ScaleButtonView({ click: (=> @_zoomOut()), value: "-"}).$el)
    @$el.append(new ScaleNumberView({model:@model}).$el)
    @$el.append(new ScaleButtonView({ click: (=> @_zoomIn()), value: "+"}).$el)

    @

  _zoomOut: ->
    @model.zoomOut()

  _zoomIn: ->
    @model.zoomIn()

module.exports = ScaleChangeView

