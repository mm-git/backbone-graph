__ = require('underscore')
Backbone = require('backbone')

XAxisView = require('./xAxisView')
YAxisView = require('./yAxisView')
GraphCanvasView = require('./graphCanvasView')
ScaleChangeView = require('./scaleChangeView')
RangeView = require('./rangeView')
GestureView = require('./gestureView')
ScaleData = require('../Model/scaleData')
OffsetData = require('../Model/offsetData')
RangeData = require('../Model/rangeData')
RectRegion = require('../Model/rectRegion')
GestureData = require('../Model/gestureData')
GestureDataCollection = require('../Model/gestureDataCollection')

class GraphView extends Backbone.View
  @ORIGIN_OFFSET_X : 40
  @ORIGIN_OFFSET_Y : 30
  @FONT_SIZE : 12
  @SELECT_SCROLL_WIDTH : 20

  tagName: "div"

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

    @_rangeView = new RangeView({
      model: @_xRangeData
      pos: [GraphView.ORIGIN_OFFSET_X, 0, @width - GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y]
      xAxis: @xAxis
      xScale: @_xScaleData
      xOffset: @_xOffsetData
    })
    @_rangeView.$wrap.appendTo(@$el)

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
    @listenTo(@collection, "change", =>
      @xAxis.max = @collection.xMax
      @yAxis.max = @collection.yMax
      @_yAxisView.render()
      @_graphCanvasView.render()
      @_xAxisView.render()
      @_rangeView.render()
      @_registerRangeGesture()
    )

    @listenTo(@_xScaleData, "change", =>
      @_xOffsetData.scroll(0)
      @_graphCanvasView.render()
      @_xAxisView.render()
      @_rangeView.render()
      @_registerRangeGesture()
    )

    @listenTo(@_xOffsetData, "change", =>
      @_graphCanvasView.scrollX()
      @_xAxisView.scrollX()
      @_rangeView.scrollX()
    )

    @listenTo(@_xRangeData, "change", =>
      @_rangeView.render()
    )

  _registerDefaultGesture: ->
    rangeGesture = new GestureData({
      region: new RectRegion(
        GraphView.ORIGIN_OFFSET_X
      , GraphView.ORIGIN_OFFSET_Y
      , =>
        divWidth = (@width - GraphView.ORIGIN_OFFSET_X) * @_xScaleData.scale / 100 - GraphView.ORIGIN_OFFSET_Y + GraphView.ORIGIN_OFFSET_X
        return Math.min(divWidth + @_xOffsetData.offset, @width) - 1
      , @height - GraphView.ORIGIN_OFFSET_Y * 2 - 1
      )
      cursor: "crosshair"
      repeat: [
        new RectRegion(null, null, GraphView.ORIGIN_OFFSET_X - 1, null)
        new RectRegion(@width - GraphView.ORIGIN_OFFSET_Y + 1, null, null, null)
      ]
    })
    .on({
      click: (mousePos) =>
        if @_xRangeData.selected == false
          @_xRangeData.autoSelectX(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X)
          @_registerRangeGesture()
      dragStart: (mousePos) =>
        @_xRangeData.selectStartX(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X)
      dragging: (mousePos) =>
        if mousePos.currentPos.x < GraphView.ORIGIN_OFFSET_X
          @_xRangeData.selectEndX(0)
        else
          @_xRangeData.selectEndX(Math.min(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X, @width - GraphView.ORIGIN_OFFSET_X))
      dragEnd: (mousePos) =>
        @_registerRangeGesture()
      repeat: (mousePos, index) =>
        if index == 0
          @_xOffsetData.scroll(GraphView.SELECT_SCROLL_WIDTH)
          @_xRangeData.selectEndX(0)
        else
          @_xOffsetData.scroll(-GraphView.SELECT_SCROLL_WIDTH)
          @_xRangeData.selectEndX(Math.min(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X, @width - GraphView.ORIGIN_OFFSET_X))
    })

    scrollGesture = new GestureData({
      region: new RectRegion(GraphView.ORIGIN_OFFSET_X, @height - GraphView.ORIGIN_OFFSET_Y * 2, @width - 1, @height - 1)
      cursor: "move"
      repeat: []
    })
    .on({
      dragging: (mousePos) =>
        @_xOffsetData.scroll(mousePos.differencePos.x)
      dragEnd: (mousePos) =>
        @_registerRangeGesture()
    })

    @_gestureCollection = new GestureDataCollection([rangeGesture, scrollGesture])
    @_gestureView = new GestureView({
      el: @$el
      collection: @_gestureCollection
    })

  _rangeGestures = []
  _registerRangeGesture: ->
    @_gestureCollection.remove(_rangeGestures)
    _rangeGestures = []

    if @_xRangeData.selected
      screenStart = @_xRangeData.screenStart + GraphView.ORIGIN_OFFSET_X
      screenEnd = @_xRangeData.screenEnd + GraphView.ORIGIN_OFFSET_X
      repeat = [
        new RectRegion(null, null, GraphView.ORIGIN_OFFSET_X - 1, null)
        new RectRegion(@width - GraphView.ORIGIN_OFFSET_Y + 1, null, null, null)
      ]

      if screenStart >= GraphView.ORIGIN_OFFSET_X && screenStart <= @width
        rangeStartGesture = new GestureData({
          region: new RectRegion(
            screenStart-3
          , GraphView.ORIGIN_OFFSET_Y
          , screenStart+3
          , @height - GraphView.ORIGIN_OFFSET_Y * 2 - 1
          )
          cursor: "col-resize"
          repeat: repeat
        })
        .on({
          dragging: (mousePos) =>
            if mousePos.currentPos.x < GraphView.ORIGIN_OFFSET_X
              @_xRangeData.selectStartX(0)
            else
              @_xRangeData.selectStartX(Math.min(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X, @width - GraphView.ORIGIN_OFFSET_X))
          dragEnd: (mousePos) =>
            @_registerRangeGesture()
          repeat: (mousePos, index) =>
            if index == 0
              @_xOffsetData.scroll(GraphView.SELECT_SCROLL_WIDTH)
              @_xRangeData.selectStartX(0)
            else
              @_xOffsetData.scroll(-GraphView.SELECT_SCROLL_WIDTH)
              @_xRangeData.selectStartX(Math.min(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X, @width - GraphView.ORIGIN_OFFSET_X))
        })

        @_gestureCollection.add(rangeStartGesture)
        _rangeGestures.push(rangeStartGesture)

      range = [screenStart, screenEnd].sort()
      range[0] += 3
      range[1] -= 3
      if range[0] >= range[1]
        return

      if screenEnd >= GraphView.ORIGIN_OFFSET_X && screenEnd <= @width
        rangeEndGesture = new GestureData({
          region: new RectRegion(
            screenEnd-3
          , GraphView.ORIGIN_OFFSET_Y
          , screenEnd+3
          , @height - GraphView.ORIGIN_OFFSET_Y * 2 - 1
          )
          cursor: "col-resize"
          repeat: repeat
        })
        .on({
          dragging: (mousePos) =>
            if mousePos.currentPos.x < GraphView.ORIGIN_OFFSET_X
              @_xRangeData.selectEndX(0)
            else
              @_xRangeData.selectEndX(Math.min(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X, @width - GraphView.ORIGIN_OFFSET_X))
          dragEnd: (mousePos) =>
            @_registerRangeGesture()
          repeat: (mousePos, index) =>
            if index == 0
              @_xOffsetData.scroll(GraphView.SELECT_SCROLL_WIDTH)
              @_xRangeData.selectEndX(0)
            else
              @_xOffsetData.scroll(-GraphView.SELECT_SCROLL_WIDTH)
              @_xRangeData.selectEndX(Math.min(mousePos.currentPos.x - GraphView.ORIGIN_OFFSET_X, @width - GraphView.ORIGIN_OFFSET_X))
        })
        @_gestureCollection.add(rangeEndGesture)
        _rangeGestures.push(rangeEndGesture)

      if range[0] <= @width && range[1] >= GraphView.ORIGIN_OFFSET_X
        rangeGesture = new GestureData({
          region: new RectRegion(
            Math.max(range[0], GraphView.ORIGIN_OFFSET_X)
          , GraphView.ORIGIN_OFFSET_Y
          , Math.min(range[1], @width)
          , @height - GraphView.ORIGIN_OFFSET_Y * 2 - 1
          )
          cursor: "move"
          repeat: repeat
        })
        @_gestureCollection.add(rangeGesture)
        _rangeGestures.push(rangeGesture)

module.exports = GraphView

