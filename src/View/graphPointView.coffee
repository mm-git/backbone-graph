$ = require('jquery')
Backbone = require('backbone')
AxisData = require('../Model/axisData.coffee')

class GraphPointView extends Backbone.View
  initialize: (options) ->
    @_axis = options._axis
    @listenTo(@_axis, AxisData.EVENT_AXIS_REDRAW, => @render())

  render: ->
    @_drawPoint()

  _drawPoint: ->
    if @model.pointList.length == 0
      return

    GraphView = require('./graphView.coffee')

    context = @$el[0].getContext('2d')
    w = @$el[0].width
    h = @$el[0].height
    xs = GraphView.ORIGIN_OFFSET_X      # x start
    xe = w - GraphView.ORIGIN_OFFSET_Y  # x end
    ys = h - GraphView.ORIGIN_OFFSET_Y  # y start
    ye = GraphView.ORIGIN_OFFSET_Y      # y end

    context.fillStyle = @model.pointColor
    @model.pointList.forEach((point) =>
      xp = xs + (xe - xs) * point.x / @_axis.xMax
      yp = ys + (ye - ys) * point.y / @_axis.yMax
      context.beginPath()
      context.moveTo(xp-5, yp-7)
      context.lineTo(xp+5, yp-7)
      context.lineTo(xp, yp)
      context.fill()
    )

module.exports = GraphPointView
