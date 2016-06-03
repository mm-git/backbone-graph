__ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')

class GraphLineView extends Backbone.View
  _graphLineOptions = ['xAxis', 'yAxis']

  initialize: (options) ->
    __.extend(@, __.pick(options, _graphLineOptions))

  render: ->
    GraphView = require('./graphView')

    context = @$el[0].getContext('2d')
    w = @$el[0].width
    h = @$el[0].height
    xs = 0                              # x start
    xe = w - GraphView.ORIGIN_OFFSET_Y  # x end
    ys = h                              # y start
    ye = GraphView.ORIGIN_OFFSET_Y      # y end

    @_drawLine(context, xs, xe, ys, ye)
    @_drawPeak(context, xs, xe, ys, ye)

  _drawLine: (context, xs, xe, ys, ye) ->
    if @model.pointList.length == 0
      return

    context.strokeStyle = @model.lineColor
    context.fillStyle = @model.lineColor
    context.beginPath()
    xp = xs + (xe - xs) * @model.pointList[0].x / @xAxis.max
    yp = ys + (ye - ys) * @model.pointList[0].y / @yAxis.max
    context.moveTo(xp, yp)
    @model.pointList.forEach((point, index) =>
      if index > 0
        xp = xs + (xe - xs) * point.x / @xAxis.max
        yp = ys + (ye - ys) * point.y / @yAxis.max
        context.lineTo(xp, yp)
    )
    context.lineTo(xp, ys)
    context.lineTo(xs, ys)
    context.closePath()
    context.fill()
    context.stroke()

  _drawPeak: (context, xs, xe, ys, ye) ->
    if @model.peakList.length == 0
      return

    context.fillStyle = @model.peakColor
    @model.peakList.forEach((peak) =>
      xp = xs + (xe - xs) * peak.point.x / @xAxis.max
      yp = ys + (ye - ys) * peak.point.y / @yAxis.max
      context.beginPath()
      context.arc(xp, yp, 1.5, 0, Math.PI*2, false)
      context.fill()
    )

module.exports = GraphLineView
