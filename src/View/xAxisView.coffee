__ = require('underscore')
$ = require('jquery')
CanvasView = require('./canvasView')

class XAxisView extends CanvasView
  _axisOptions = ['xScale']

  initialize: (options) ->
    super(options)
    __.extend(@, __.pick(options, _axisOptions))
    @_offsetX = 0

  render: ->
    scrollXMax = @pos[2] - @pos[2] * @xScale.scale / 100
    if @_offsetX < scrollXMax
      @_offsetX = scrollXMax

    w = @pos[2] * @xScale.scale / 100
    h = @pos[3]

    @$el
    .css({
      position: "relative"
      left: @_offsetX
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
    context.fillText("0", xs + 3, h - 3)

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
        context.fillText("#{x}", xp, ys - 3)
      else if drawSub
        context.fillText("#{x}", xp, ys - 3)

    return
        
  scrollX: (offset, refresh) ->
    scrollXMax = @pos[2] - @pos[2] * @xScale.scale / 100

    if @_offsetX + offset > 0
      @$el
      .css({
        left: 0
      })

      if refresh
        @_offsetX = 0

    else if @_offsetX + offset < scrollXMax
      @$el
      .css({
        left: scrollXMax
      })

      if refresh
        @_offsetX = scrollXMax

    else
      @$el
      .css({
        left: @_offsetX + offset
      })

      if refresh
        @_offsetX += offset

module.exports = XAxisView
