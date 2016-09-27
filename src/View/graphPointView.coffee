__ = require('underscore')
Backbone = require('backbone')

class GraphPointView extends Backbone.View
  _graphPointOptions = ['xAxis', 'yAxis']

  initialize: (options) ->
    __.extend(@, __.pick(options, _graphPointOptions))
    @drawPointList = []

  render: ->
    GraphView = require('./graphView')

    context = @$el[0].getContext('2d')
    w = @$el[0].width
    h = @$el[0].height
    xs = 0                              # x start
    xe = w - GraphView.ORIGIN_OFFSET_Y  # x end
    ys = h                              # y start
    ye = GraphView.ORIGIN_OFFSET_Y      # y end

    @_drawPoint(context, xs, xe, ys, ye)

  _drawPoint: (context, xs, xe, ys, ye) ->
    @drawPointList = []
    if @model.pointList.length == 0
      return

    context.fillStyle = @model.pointColor
    @model.pointList.forEach((point) =>
      xp = xs + (xe - xs) * point.x / @xAxis.max
      yp = ys + (ye - ys) * point.y / @yAxis.max
      context.beginPath()
      context.moveTo(xp-5, yp-7)
      context.lineTo(xp+5, yp-7)
      context.lineTo(xp, yp)
      context.fill()

      @drawPointList.push({
        x: xp
        y: yp
      })
    )

module.exports = GraphPointView
