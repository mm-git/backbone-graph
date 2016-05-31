$ = require('jquery')
Backbone = require('backbone')
GraphCanvasView = require('./GraphCanvasView')
ScaleChangeView = require('./scaleChangeView')
ScaleData = require('../Model/scaleData')

class GraphView extends Backbone.View
  @ORIGIN_OFFSET_X : 40
  @ORIGIN_OFFSET_Y : 20
  @FONT_SIZE : 12

  tagName: "div"

  #options =
  # pos: [x, y, width, height]
  # xAxis:AxisClassObject
  # yAxis:AxisClassObject
  # axisColor: "#RRGGBB"
  # scaleColor: "#RRGGBB"
  initialize: (options) ->
    @_xScaleData = new ScaleData({
      title: "X : "
    })
    @_xScaleChangeView = new ScaleChangeView({
      model: @_xScaleData
      scaleColor: @scaleColor
      left: 50
    })
    @_xScaleChangeView.$el.appendTo(@$el)

    @_graphCanvasView = new GraphCanvasView({
      collection: @collection
      pos: options.pos
      xAxis: options.xAxis
      yAxis: options.yAxis
      axisColor: options.axisColor
    })
    @_graphCanvasView.$el.appendTo(@$el)

module.exports = GraphView

