$ = require('jquery')
Backbone = require('backbone')
AxisData = require('../Model/axisData.coffee')

class AxisView extends Backbone.View
  initialize: (options) ->
    @_axisColor = options._axisColor
    @render()
    @listenTo(@model, AxisData.EVENT_AXIS_CHANGED, (model) =>
      @render()
      model.notifyRedraw()
    )

  render: ->
    GraphView = require('./graphView.coffee')

    context = @$el[0].getContext('2d')
    w = @$el[0].width
    h = @$el[0].height
    xs = GraphView.ORIGIN_OFFSET_X      # x start
    xe = w - GraphView.ORIGIN_OFFSET_Y  # x end
    ys = h - GraphView.ORIGIN_OFFSET_Y  # y start
    ye = GraphView.ORIGIN_OFFSET_Y      # y end

    #axis
    context.clearRect(0, 0, w, h)
    context.font = "#{GraphView.NUMBER_FONT_SIZE}px Arial"
    context.fillStyle = @_axisColor
    context.strokeStyle = @_axisColor

    # draw origin
    context.textAlign="left"
    context.textBaseline="bottom"
    context.fillText("0", GraphView.ORIGIN_OFFSET_X, h - 3)

    # draw x axis
    context.textAlign="center"
    context.textBaseline="bottom"

    context.lineWidth = 1
    context.beginPath()
    context.moveTo(xs, ys)
    context.lineTo(xe, ys)
    context.stroke()

    context.lineWidth = 0.5
    drawSub = (xs + (xe - xs) * @model.xAxis.subInterval / @model.xMax) > 80
    for x in [@model.xAxis.subInterval ... @model.xMax] by @model.xAxis.subInterval
      xp = xs + (xe - xs) * x / @model.xMax
      if x % @model.xAxis.interval == 0
        context.fillText("#{x}", xp, h - 3);
        context.beginPath()
        context.moveTo(xp, ys)
        context.lineTo(xp, ye)
        context.stroke()
      else if drawSub
        context.fillText("#{x}", xp, h - 3);
        context.beginPath()
        context.moveTo(xp, ys)
        context.lineTo(xp, ys-4)
        context.stroke()

    # draw y axis
    context.textAlign="right"
    context.textBaseline="middle"

    context.lineWidth = 1
    context.beginPath()
    context.moveTo(xs, ys)
    context.lineTo(xs, ye)
    context.stroke()

    context.lineWidth = 0.5
    drawSub = (ye + (ys - ye) * @model.yAxis.subInterval / @model.yMax) > 50
    for y in [@model.yAxis.subInterval ... @model.yMax] by @model.yAxis.subInterval
      yp = ys + (ye - ys) * y / @model.yMax
      if y % @model.yAxis.interval == 0
        context.fillText("#{y}", xs-3, yp);
        context.beginPath()
        context.moveTo(xs, yp)
        context.lineTo(xe, yp)
        context.stroke()
      else if drawSub
        context.fillText("#{y}", xs-3, yp);
        context.beginPath()
        context.moveTo(xs, yp)
        context.lineTo(xs+4, yp)
        context.stroke()

module.exports = AxisView
