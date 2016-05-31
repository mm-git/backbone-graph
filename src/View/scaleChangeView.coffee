__ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')

class ScaleChangeView extends Backbone.View
  @SCALE_FONT_SIZE: 10

  tagName: "div"
  template: __.template("<span><%= title %></span>"),

  initialize: (options) ->
    @_scaleColor = options.scaleColor
    @_left = options.left
    @render()

  render: ->
    @$el
    .html(@template({
      title: @model.title
    }))
    .css({
      position: "absolute"
      left: @_left
      top: 0
      fontSize: ScaleChangeView.SCALE_FONT_SIZE
      color: @_scaleColor
    })

    @

module.exports = ScaleChangeView

