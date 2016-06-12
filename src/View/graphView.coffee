__ = require('underscore')
$ = global.$ || require('jquery')
Backbone = require('backbone')

XAxisView = require('./xAxisView')
YAxisView = require('./yAxisView')
GraphCanvasView = require('./graphCanvasView')
ScaleChangeView = require('./scaleChangeView')
RangeView = require('./rangeView')
ScaleData = require('../Model/scaleData')
OffsetData = require('../Model/offsetData')
RangeData = require('../Model/rangeData')

class GraphView extends Backbone.View
  @ORIGIN_OFFSET_X : 40
  @ORIGIN_OFFSET_Y : 20
  @FONT_SIZE : 12

  tagName: "div"

  events:
    mousedown: "_onMouseDown"
    mousemove: "_onMouseMove"
    mouseup: "_onMouseUp"
    dblclick: "_onDoubleClick"

  _graphOptions = ['width', 'height', 'xAxis', 'yAxis', 'range']
    
  #options =
  #  collection: GraphDataCollectionClassObject
  #  width: w
  #  height: h
  #  xAxis:AxisDataClassObject
  #  yAxis:AxisDataClassObject
  #  range:
  #    color: "##RRGGBB"
  #    opacity: o
  initialize: (options) ->
    __.extend(@, __.pick(options, _graphOptions))
    @_scrolling = false
    @_startX = 0

    @_xScaleData = new ScaleData({title: "X"})
    @_yScaleData = new ScaleData({title: "Y"})
    @_xOffsetData = new OffsetData({
      width: @width - GraphView.ORIGIN_OFFSET_X
      scale: @_xScaleData
    })
    @_xRangeData = new RangeData({
      width: @width - GraphView.ORIGIN_OFFSET_X
      scale: @_xScaleData
      axis: @xAxis
      offset: @_xOffsetData
      targetGraph: @collection.models[0]
      rangeColor: @range.color
      rangeOpacity: @range.opacity
    })

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
      xOffset: @_xOffsetData
    })
    @_graphCanvasView.$wrap.appendTo(@$el)

    @_xAxisView = new XAxisView({
      model: @xAxis
      pos: [GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y, @width - GraphView.ORIGIN_OFFSET_X, GraphView.ORIGIN_OFFSET_Y]
      xScale: @_xScaleData
      xOffset: @_xOffsetData
    })
    @_xAxisView.$wrap.appendTo(@$el)

    @_RangeView = new RangeView({
      model: @_xRangeData
      pos: [GraphView.ORIGIN_OFFSET_X, 0, @width - GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y]
      xAxis: @xAxis
      xScale: @_xScaleData
      xOffset: @_xOffsetData
    })
    @_RangeView.$wrap.appendTo(@$el)

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

    __.bindAll(@, "_onMouseDown", "_onMouseMove", "_onMouseUp", "_onDoubleClick")
    $(document).on('mousemove', (event) => @_onMouseMove(event))
    $(document).on('mouseup', (event) => @_onMouseUp(event))
    $(document).on('dragend', (event) => @_onMouseUp(event))

    @listenTo(@collection, "change", =>
      @xAxis.max = @collection.xMax
      @yAxis.max = @collection.yMax
      @_yAxisView.render()
      @_graphCanvasView.render()
      @_xAxisView.render()
      @_RangeView.render()
    )

    @listenTo(@_xScaleData, "change", =>
      @_xOffsetData.scroll(0, true)
      @_graphCanvasView.render()
      @_xAxisView.render()
      @_RangeView.render()
    )

    @listenTo(@_xOffsetData, "change", =>
      @_graphCanvasView.scrollX()
      @_xAxisView.scrollX()
      @_RangeView.scrollX()
    )

    @listenTo(@_xRangeData, "change", =>
      @_RangeView.render()
    )

  _onMouseDown: (event) ->
    mousePos = @_getMousePos(event)

    if mousePos.y > @height - GraphView.ORIGIN_OFFSET_Y * 2
      @_scrolling = true
      @_startX = mousePos.x

  _onMouseMove: (event) ->
    if @_scrolling
      mousePos = @_getMousePos(event)
      offset = mousePos.x - @_startX
      @_xOffsetData.scroll(offset, false)

  _onMouseUp: (event) ->
    if @_scrolling
      mousePos = @_getMousePos(event)
      offset = mousePos.x - @_startX
      @_xOffsetData.scroll(offset, true)
    @_scrolling = false

  _onDoubleClick: (event) ->
    mousePos = @_getMousePos(event)

    if mousePos.x < GraphView.ORIGIN_OFFSET_X || mousePos.x > @width
      return

    if mousePos.y > @height - GraphView.ORIGIN_OFFSET_Y * 2
      return

    @_xRangeData.autoSelect(mousePos.x - GraphView.ORIGIN_OFFSET_X)

  _getMousePos: (event) ->
    elementPos = @$el[0].getBoundingClientRect()
    return {
      x : event.pageX - elementPos.left - window.pageXOffset
      y : event.pageY - elementPos.top - window.pageYOffset
    }

module.exports = GraphView

