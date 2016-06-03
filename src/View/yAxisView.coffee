__ = require('underscore')
$ = require('jquery')
CanvasView = require('./canvasView')

class YAxisView extends CanvasView
  _axisOptions = ['yScale']

  initialize: (options) ->
    super(options)
    __.extend(@, __.pick(options, _axisOptions))
    @_offsetY = 0

  render: ->
    scrollYMax = @pos[3] * @yScale.scale / 100 - @pos[3]
    if @_offsetY > scrollYMax
      @_offsetY = scrollYMax

    w = @pos[2]
    h = @pos[3] * @yScale.scale / 100

    @$el
    .css({
      position: "relative"
      left: 0
      top: @_offsetY
      width: w
      height: h
    })
    @$el[0].width = w
    @$el[0].height = h

    GraphView = require('./graphView')

    context = @$el[0].getContext('2d')
    xs = 0                         # x start
    xe = w                         # x end
    ys = h                         # y start
    ye = GraphView.ORIGIN_OFFSET_Y # y end

    context.clearRect(0, 0, w, h)
    context.font = "#{GraphView.FONT_SIZE}px Arial"
    context.fillStyle = @model.axisColor
    context.strokeStyle = @model.axisColor

    # draw y axis
    context.lineWidth = 1
    context.beginPath()
    context.moveTo(xe, ys)
    context.lineTo(xe, ye)
    context.stroke()

    context.textAlign="right"
    context.textBaseline="middle"
    adjustXInterval = @yScale.adjustInterval

    drawSub = (ye + (ys - ye) * @model.subInterval / @model.max * adjustXInterval) > 50
    for y in [@model.subInterval / adjustXInterval .. @model.max] by @model.subInterval / adjustXInterval
      yp = ys + (ye - ys) * y / @model.max
      if y % @model.interval == 0
        context.fillText("#{y}", xe-3, yp)
      else if drawSub
        context.fillText("#{y}", xe-3, yp)
    return

module.exports = YAxisView
