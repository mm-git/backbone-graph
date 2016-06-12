__ = require('underscore')
CanvasView = require('./canvasView')

class XAxisView extends CanvasView
  _axisOptions = ['xScale', 'xOffset']

  initialize: (options) ->
    super(options)
    __.extend(@, __.pick(options, _axisOptions))

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
    ye = 0                              # y end

    context.clearRect(0, 0, w, h)
    context.font = "#{GraphView.FONT_SIZE}px Arial"
    context.fillStyle = @model.axisColor
    context.strokeStyle = @model.axisColor

    # draw origin
    context.textAlign="left"
    context.textBaseline="bottom"
    context.fillText("0", xs + 3, ye + 17)

    # draw x axis
    context.lineWidth = 1
    context.beginPath()
    context.moveTo(xs, ye)
    context.lineTo(xe, ye)
    context.stroke()

    context.textAlign="center"
    context.textBaseline="bottom"
    adjustXInterval = @xScale.adjustInterval

    drawSub = (xs + (xe - xs) * @model.subInterval / (@model.max * adjustXInterval)) > 40
    for x in [@model.subInterval / adjustXInterval .. @model.max] by @model.subInterval / adjustXInterval
      xp = xs + (xe - xs) * x / @model.max
      if x % (@model.interval / adjustXInterval) == 0
        context.fillText("#{x}", xp, ye + 17)
      else if drawSub
        context.fillText("#{x}", xp, ye + 17)

    return

  scrollX: ->
    @$el
    .css({
      left: @xOffset.offset
    })

module.exports = XAxisView
