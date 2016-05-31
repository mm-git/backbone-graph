__ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')
GraphData = require('../Model/graphData')
AxisData = require('../Model/axisData')
GraphLineView = require('./graphLineView')
GraphPointView = require('./graphPointView')
AxisView = require('./axisView')

class GraphCanvasView extends Backbone.View
  tagName: "canvas"

  _graphOptions = ['pos', 'xAxis', 'yAxis', 'axisColor']

  #options = {pos: [x, y, width, height], xAxis:AxisClassObject, yAxis:AxisClassObject, axisColor: "#RRGGBB"}
  initialize: (options) ->
    __.extend(@, __.pick(options, _graphOptions))
    @render()

    @_axisData = new AxisData({
      xAxis: @xAxis
      yAxis: @yAxis
    })
    @_axisView = new AxisView({
      el: @$el
      model: @_axisData
      axisColor: @axisColor
    })
    @_subView = @collection.map((model) =>
      subView = null
      switch model.type
        when GraphData.TYPE.LINE
          subView = new GraphLineView({
            el: @$el
            model: model
            axis: @_axisData
          })
        when GraphData.TYPE.POINT
          subView = new GraphPointView({
            el: @$el
            model: model
            axis: @_axisData
          })
      return subView
    )

    @listenTo(@collection, "change", (collection) =>
      @_axisData.setMaximum(collection.xMax, collection.yMax)
    )

  render: ->
    @$el
    .css({
      position: "absolute"
      left: @pos[0]
      top: @pos[1]
      width: @pos[2]
      height: @pos[3]
    })
    @$el[0].width = @pos[2]
    @$el[0].height = @pos[3]

    @

module.exports = GraphCanvasView