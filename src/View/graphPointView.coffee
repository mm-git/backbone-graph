__ = require('underscore')
Backbone = require('backbone')
GraphPointData = require('../Model/graphPointData')

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

    @model.pointList.forEach((point, index) =>
      context.fillStyle = @model.attributeList[index].color

      xp = xs + (xe - xs) * point.x / @xAxis.max
      yp = ys + (ye - ys) * point.y / @yAxis.max

      switch @model.attributeList[index].shape
        when GraphPointData.SHAPE.CIRCLE
          context.beginPath();
          context.arc(xp, yp, 4, 0, Math.PI*2, false);
          context.fill();
        when GraphPointData.SHAPE.DOWNWARD_TRIANGLE
          context.beginPath()
          context.moveTo(xp-5, yp-7)
          context.lineTo(xp+5, yp-7)
          context.lineTo(xp, yp)
          context.fill()
        when GraphPointData.SHAPE.TRIANGLE
          context.beginPath()
          context.moveTo(xp-5, yp+7)
          context.lineTo(xp+5, yp+7)
          context.lineTo(xp, yp)
          context.fill()
        when GraphPointData.SHAPE.SQUARE
          context.beginPath()
          context.fillRect(xp-4, yp-4, 8, 8)
        when GraphPointData.SHAPE.DIAMOND
          context.beginPath()
          context.moveTo(xp, yp-5)
          context.lineTo(xp+5, yp)
          context.lineTo(xp, yp+5)
          context.lineTo(xp-5, yp)
          context.fill()

      @drawPointList.push({
        x: xp
        y: yp
      })
    )

module.exports = GraphPointView
