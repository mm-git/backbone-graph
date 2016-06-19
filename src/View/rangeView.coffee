__ = require('underscore')
CanvasView = require('./canvasView')

class RangeView extends CanvasView
  _rangeOptions = ['xAxis', 'xScale', 'xOffset']

  initialize: (options) ->
    super(options)
    __.extend(@, __.pick(options, _rangeOptions))
    @render()

  render: ->
    w = @pos[2] * @xScale.scale / 100
    h = @pos[3]

    @$el
    .css({
      position: "relative"
      left: @xOffset.offset
      top: 0
      width: w
      height: h
    })
    @$el[0].width = w
    @$el[0].height = h

    GraphView = require('./graphView')

    context = @$el[0].getContext('2d')
    xs = 0                              # x start
    xe = w - GraphView.ORIGIN_OFFSET_Y  # x end
    ys = h                              # y start
    ye = GraphView.ORIGIN_OFFSET_Y      # y end

    context.clearRect(0, 0, w, h)

    if @model.selected == false
      return

    # draw range
    context.fillStyle = @model.rangeColor
    context.strokeStyle = @model.rangeColor
    context.globalAlpha = @model.rangeOpacity

    xStart = xs + (xe - xs) * @model.start / @xAxis.max
    xEnd = xs + (xe - xs) * @model.end / @xAxis.max
    context.fillRect(xStart, ye, xEnd-xStart, ys - ye)

    return

  scrollX: ->
    @$el
    .css({
      left: @xOffset.offset
    })

module.exports = RangeView
