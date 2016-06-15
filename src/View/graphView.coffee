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
RectRegion = reauire('../Model/rectRegion')
GestureData = require('../Mofel/gestureData')
GestureDataCollection = require('../Mofel/gestureDataCollection')

class GraphView extends Backbone.View
  @ORIGIN_OFFSET_X : 40
  @ORIGIN_OFFSET_Y : 30
  @FONT_SIZE : 12
  @SELECT__SCROLL_WIDTH : 20
  @SELECT__SCROLL_INTERVAL : 200

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
    @_selecting = false
    @_lastX = 0
    @_selectScrollTimer = null

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

    @render()
    @_registerEvent()
    @_registerDefaultGesture()

  render: ->
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

    @

  _registerEvent: ->
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
      @_registerRangeGesture()
    )

    @listenTo(@_xScaleData, "change", =>
      @_xOffsetData.scroll(0, true)
      @_graphCanvasView.render()
      @_xAxisView.render()
      @_RangeView.render()
      @_registerRangeGesture()
    )

    @listenTo(@_xOffsetData, "change", =>
      @_graphCanvasView.scrollX()
      @_xAxisView.scrollX()
      @_RangeView.scrollX()
      @_registerRangeGesture()
    )

    @listenTo(@_xRangeData, "change", =>
      @_RangeView.render()
      @_registerRangeGesture()
    )

  _registerDefaultGesture: ->
    rengeGesture = new GestureData({
      region: new RectRegion(x1,y1,x2,=> hoge.x)
      cursor: "move"
      repeat: [
        new RectRegion(x1,  null,null,null)
        new RectRegion(null,null,x2,  null)
      ]
    })
    .on({
      click: (event) =>

      over: (event) =>

      drag: (event) =>

      repeat: (event, index) =>

    })

    scrollGesture = new GestureData({
      region: new RectRegion(x1,y1,x2,=> hoge.x)
      cursor: "move"
    })
    .on({
      drag: (event) =>

    })

    @_gestureCollection = new GestureDataCollection([rengeGesture, scrollGesture])
    @_gestureView = new GestureView({
      el: @$el
      collection: @_gestureCollection
    })

  _rengeGestures = []
  _registerRangeGesture: ->
    @_gestureCollection.remove(_rengeGestures)
    _rengeGestures = []

    if @_xRangeData.selected
      _rengeGestures = []


  _onMouseDown: (event) ->
    mousePos = @_getMousePos(event)

    if mousePos.y > GraphView.ORIGIN_OFFSET_Y && mousePos.y < @height - GraphView.ORIGIN_OFFSET_Y * 2
      @_selecting = true
      @_xRangeData.selectStartX(mousePos.x - GraphView.ORIGIN_OFFSET_X)
    else if mousePos.y > @height - GraphView.ORIGIN_OFFSET_Y * 2
      @_scrolling = true
      @_lastX = mousePos.x

  _onMouseMove: (event) ->
    mousePos = @_getMousePos(event)

    if @_selecting
      if mousePos.x < GraphView.ORIGIN_OFFSET_X
        @_xRangeData.selectEndX(0)
        @_startSelectScrolling(GraphView.SELECT__SCROLL_WIDTH, 0)
      else if mousePos.x > @width - GraphView.ORIGIN_OFFSET_Y
        offsetX = mousePos.x - GraphView.ORIGIN_OFFSET_X
        if mousePos.x > @width
          offsetX = @width - GraphView.ORIGIN_OFFSET_X

        @_xRangeData.selectEndX(offsetX)
        @_startSelectScrolling(-GraphView.SELECT__SCROLL_WIDTH, offsetX)
      else
        @_stopSelectScrolling()
        @_xRangeData.selectEndX(mousePos.x - GraphView.ORIGIN_OFFSET_X)
    else if @_scrolling
      offset = mousePos.x - @_lastX
      @_lastX = mousePos.x
      @_xOffsetData.scroll(offset)

  _onMouseUp: (event) ->
    mousePos = @_getMousePos(event)

    if @_selecting
      @_stopSelectScrolling()
      offsetX = mousePos.x - GraphView.ORIGIN_OFFSET_X
      if mousePos.x < GraphView.ORIGIN_OFFSET_X
        offsetX = 0
      else if mousePos.x > @width
        offsetX = @width - GraphView.ORIGIN_OFFSET_X

      @_xRangeData.selectEndX(offsetX)
    else if @_scrolling
      offset = mousePos.x - @_lastX
      @_xOffsetData.scroll(offset)

    @_selecting = false
    @_scrolling = false

  _onDoubleClick: (event) ->
    mousePos = @_getMousePos(event)

    if mousePos.x < GraphView.ORIGIN_OFFSET_X || mousePos.x > @width
      return

    if mousePos.y < GraphView.ORIGIN_OFFSET_Y || mousePos.y > @height - GraphView.ORIGIN_OFFSET_Y * 2
      return

    @_xRangeData.autoSelectX(mousePos.x - GraphView.ORIGIN_OFFSET_X)

  _selectX = 0
  _startSelectScrolling: (scrollAmount, selectX) ->
    _selectX = selectX
    if @_selectScrollTimer == null
      @_selectScrollTimer = setInterval( =>
        @_xOffsetData.scroll(scrollAmount)
        @_xRangeData.selectEndX(_selectX)
      , GraphView.SELECT__SCROLL_INTERVAL
      )

  _stopSelectScrolling: ->
    if @_selectScrollTimer != null
      clearTimeout(@_selectScrollTimer)
      @_selectScrollTimer = null

  _selectScrolling: ->
    @_xOffsetData.scroll(offset)

  _getMousePos: (event) ->
    elementPos = @$el[0].getBoundingClientRect()
    return {
      x : event.pageX - elementPos.left - window.pageXOffset
      y : event.pageY - elementPos.top - window.pageYOffset
    }

module.exports = GraphView

