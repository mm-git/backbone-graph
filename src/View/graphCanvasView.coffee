__ = require('underscore')
GraphData = require('../Model/graphData')
CanvasView = require('./canvasView')
GraphLineView = require('./graphLineView')
GraphPointView = require('./graphPointView')

class GraphCanvasView extends CanvasView
  _graphCanvasOptions = ['xAxis', 'yAxis', 'xScale', 'yScale']

  initialize: (options) ->
    super(options)
    __.extend(@, __.pick(options, _graphCanvasOptions))
    @_offsetX = 0
        
    @_subView = @collection.map((model) =>
      subView = null
      switch model.type
        when GraphData.TYPE.LINE
          subView = new GraphLineView({
            el: @$el
            model: model
            xAxis: @xAxis
            yAxis: @yAxis
          })
        when GraphData.TYPE.POINT
          subView = new GraphPointView({
            el: @$el
            model: model
            xAxis: @xAxis
            yAxis: @yAxis
          })
      return subView
    )
    
    @render()

  render: ->
    scrollXMax = @pos[2] - @pos[2] * @xScale.scale / 100
    if @_offsetX < scrollXMax
      @_offsetX = scrollXMax

    w = @pos[2] * @xScale.scale / 100
    h = @pos[3] * @yScale.scale / 100
    
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
    ye = GraphView.ORIGIN_OFFSET_Y      # y end
    context.clearRect(0, 0, w, h)

    @_drawAxis(context, xs, xe, ys, ye)

    @_subView.forEach((subView) =>
      subView.render()
    )
    
    @

  _drawAxis: (context, xs, xe, ys, ye) ->
    context.lineWidth = 0.5

    #x axis
    context.strokeStyle = @xAxis.axisColor
    context.fillStyle = @xAxis.axisColor

    for x in [0 .. @xAxis.max] by @xAxis.interval / @xScale.adjustInterval
      xp = xs + (xe - xs) * x / @xAxis.max
      context.beginPath()
      context.moveTo(xp, ys)
      context.lineTo(xp, ye)
      context.stroke()

    #y axis
    context.strokeStyle = @yAxis.axisColor
    context.fillStyle = @yAxis.axisColor

    for y in [0 .. @yAxis.max] by @yAxis.interval / @yScale.adjustInterval
      yp = ys + (ye - ys) * y / @yAxis.max
      context.beginPath()
      context.moveTo(xs, yp)
      context.lineTo(xe, yp)
      context.stroke()
           
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

module.exports = GraphCanvasView
