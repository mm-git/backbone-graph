__ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')

class ScaleButtonView extends Backbone.View
  # Backbone.View definition
  tagName: "button"
  className: "backbone_graph_scale_button backbone_graph_scale_button_private"

  events:
    click: "_onClick"

  initialize: (options) ->
    __.bindAll(@, "_onClick")
    @_value = options.value
    @_click = options.click

    @render()

  render: ->
    @$el
    .html(@_value)

    @

  _onClick: ->
    @_click()

module.exports = ScaleButtonView