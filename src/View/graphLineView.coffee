$ = require('jquery')
Backbone = require('backbone')
AxisData = require('../Model/axisData.coffee')

class GraphLineView extends Backbone.View
  initialize: (options) ->
    @_axis = options._axis
    @listenTo(@_axis, AxisData.EVENT_AXIS_REDRAW, => @render())

  render: ->
    @_drawLine()
    @_drawPeak()

  _drawLine: ->
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

    context.strokeStyle = @model.lineColor
    context.fillStyle = @model.lineColor
    context.beginPath()
    xp = xs + (xe - xs) * @model.pointList[0].x / @_axis.xMax
    yp = ys + (ye - ys) * @model.pointList[0].y / @_axis.yMax
    context.moveTo(xp, yp)
    @model.pointList.forEach((point, index) =>
      if index > 0
        xp = xs + (xe - xs) * point.x / @_axis.xMax
        yp = ys + (ye - ys) * point.y / @_axis.yMax
        context.lineTo(xp, yp)
    )
    context.lineTo(xp, ys)
    context.lineTo(xs, ys)
    context.closePath()
    context.fill()
    context.stroke()

  _drawPeak: ->
    if @model.peakList.length == 0
      return

    GraphView = require('./graphView.coffee')

    context = @$el[0].getContext('2d')
    w = @$el[0].width
    h = @$el[0].height
    xs = GraphView.ORIGIN_OFFSET_X      # x start
    xe = w - GraphView.ORIGIN_OFFSET_Y  # x end
    ys = h - GraphView.ORIGIN_OFFSET_Y  # y start
    ye = GraphView.ORIGIN_OFFSET_Y      # y end

    context.fillStyle = @model.peakColor
    @model.peakList.forEach((peak) =>
      xp = xs + (xe - xs) * peak.point.x / @_axis.xMax
      yp = ys + (ye - ys) * peak.point.y / @_axis.yMax
      context.beginPath()
      context.arc(xp, yp, 1.5, 0, Math.PI*2, false);
      context.fill()
    )
module.exports = GraphLineView
