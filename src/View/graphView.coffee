__ = require('underscore')
$ = global.$ || require('jquery')
Backbone = require('backbone')
XAxisView = require('./xAxisView')
YAxisView = require('./yAxisView')
GraphCanvasView = require('./graphCanvasView')
ScaleChangeView = require('./scaleChangeView')
ScaleData = require('../Model/scaleData')

class GraphView extends Backbone.View
  @ORIGIN_OFFSET_X : 40
  @ORIGIN_OFFSET_Y : 20
  @FONT_SIZE : 12

  tagName: "div"

  events:
    mousedown: "_onMouseDown"
    mousemove: "_onMouseMove"
    mouseup: "_onMouseUp"

  _graphOptions = ['width', 'height', 'xAxis', 'yAxis']
    
  #options =
  #  collection: GraphDataCollectionClassObject
  #  width: w
  #  height: h
  #  xAxis:AxisDataClassObject
  #  yAxis:AxisDataClassObject
  initialize: (options) ->
    __.extend(@, __.pick(options, _graphOptions))
    @_scrolling = false
    @_startX = 0

    @_xScaleData = new ScaleData({title: "X"})
    @_yScaleData = new ScaleData({title: "Y"})

    @_yAxisView = new YAxisView({
      model: @yAxis
      pos: [0, 0, GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y]
      yScale: @_yScaleData
    })
    @_yAxisView.$wrap.appendTo(@$el)

    @_graphCanvasView = new GraphCanvasView({
      collection: @collection
      pos: [GraphView.ORIGIN_OFFSET_X, 0, @width - GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y]
      xAxis: @xAxis
      yAxis: @yAxis
      xScale: @_xScaleData
      yScale: @_yScaleData
    })
    @_graphCanvasView.$wrap.appendTo(@$el)

    @_xAxisView = new XAxisView({
      model: options.xAxis
      pos: [GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y, @width - GraphView.ORIGIN_OFFSET_X, GraphView.ORIGIN_OFFSET_Y]
      xScale: @_xScaleData
    })
    @_xAxisView.$wrap.appendTo(@$el)

    @_xScaleChangeView = new ScaleChangeView({
      model: @_xScaleData
    })
    @_xScaleChangeView.$el.appendTo(@$el)

    @$el
    .css({
      left: 0
      top: 0
      width: @width
      height: @height
    })

    __.bindAll(@, "_onMouseDown", "_onMouseMove", "_onMouseUp")
    $(document).on('mousemove', (event) => @_onMouseMove(event))
    $(document).on('mouseup', (event) => @_onMouseUp(event))
    $(document).on('dragend', (event) => @_onMouseUp(event))

    @listenTo(@collection, "change", =>
      @xAxis.max = @collection.xMax
      @yAxis.max = @collection.yMax
      @_yAxisView.render()
      @_graphCanvasView.render()
      @_xAxisView.render()
    )

    @listenTo(@_xScaleData, "change", =>
      @_graphCanvasView.render()
      @_xAxisView.render()
    )

  _onMouseDown: (event) ->
    if event.clientY > @height - GraphView.ORIGIN_OFFSET_Y * 2
      @_scrolling = true
      @_startX = event.clientX

  _onMouseMove: (event) ->
    if @_scrolling
      offset = event.clientX - @_startX
      @_graphCanvasView.scrollX(offset, false)
      @_xAxisView.scrollX(offset, false)

  _onMouseUp: (event) ->
    if @_scrolling
      offset = event.clientX - @_startX
      @_graphCanvasView.scrollX(offset, true)
      @_xAxisView.scrollX(offset, true)
    @_scrolling = false

module.exports = GraphView

