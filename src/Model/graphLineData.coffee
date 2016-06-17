__ = require('underscore')
GraphData = require('./graphData')
GraphPoint = require('./graphPoint')

class GraphLineData extends GraphData
  # options = {lineColor: "#RRGGBB", peakColor: "#RRGGBB"}
  initialize: (options) ->
    super(options)
    @set('type', GraphData.TYPE.LINE)

    @_smoothList = []
    @_peakList = []
    @_totalGain = 0
    @_totalDrop = 0
    @_maxIncline = {incline:0}
    @_minIncline = {incline:0}
    @_range = {
      start: 0
      end: 0
      selected: false
    }

  @property "lineColor",
    get: ->
      @get('lineColor')

  @property "peakColor",
    get: ->
      @get('peakColor')

  @property "pointList",
    get: ->
      if @_smoothList.length > 0
        return @_smoothList
      @_pointList

  @property "peakList",
    get: ->
      @_peakList

  @property "smoothMin",
    get: ->
      if @_peakList.length == 0
        return @_min
      return @_peakList.slice().sort((a, b) -> a.point.y - b.point.y)[0].point

  @property "smoothMax",
    get: ->
      if @_peakList.length == 0
        return @_max
      return @_peakList.slice().sort((a, b) -> b.point.y - a.point.y)[0].point

  @property "totalGain",
    get: ->
      @_totalGain

  @property "totalDrop",
    get: ->
      @_totalDrop

  @property "maxIncline",
    get: ->
      @_maxIncline

  @property "minIncline",
    get: ->
      @_minIncline

  @property "isSmooth",
    get: ->
      @_smoothList.length > 0

  @property "range",
    get: ->
      @_range

  @property "rangeStart",
    get: ->
      @_range.start

  @property "rangeEnd",
    get: ->
      @_range.end

  @property "isRangeSelected",
    get: ->
      @_range.selected

  @property "rangeWidth",
    get: ->
      @_range.width

  @property "rangeMin",
    get: ->
      @_range.min

  @property "rangeMax",
    get: ->
      @_range.max

  @property "rangeGain",
    get: ->
      @_range.gain

  @property "rangeDrop",
    get: ->
      @_range.drop

  @property "rangeMaxIncline",
    get: ->
      @_range.maxIncline

  @property "rangeMinIncline",
    get: ->
      @_range.minIncline

  @property "rangeAveIncline",
    get: ->
      @_range.aveIncline

  clear: ->
    super()
    @_smoothList = []
    @_peakList = []
    @_totalGain = 0
    @_totalDrop = 0
    @_maxIncline = {incline:0}
    @_minIncline = {incline:0}

  smooth: (interval, range) ->
    # interval 間隔でグラフデータをリサンプリングする
    xp = 0
    newPointList = []
    for index in [1 ... @_pointList.length]
      incline = (@_pointList[index].y - @_pointList[index-1].y) / (@_pointList[index].x - @_pointList[index-1].x)
      while xp <= @_pointList[index].x
        yp = @_pointList[index-1].y + incline * (xp - @_pointList[index-1].x)
        newPointList.push(new GraphPoint(xp, yp))
        xp += interval

    # ±range の個数のデータで平均を取って平坦化する
    @_smoothList = []
    for index in [0 ... newPointList.length]
      start = if index-range>0 then index-range else 0
      end = if index+range<newPointList.length then index+range else newPointList.length - 1

      yTotal = 0
      for rangeIndex in [start .. end]
        yTotal += newPointList[rangeIndex].y

      @_smoothList.push(new GraphPoint(newPointList[index].x, yTotal/(end-start+1)))

    return

  unsmooth: ->
    @_smoothList = []
    @_peakList = []
    @_totalGain = 0
    @_totalDrop = 0
    @_maxIncline = {incline:0}
    @_minIncline = {incline:0}

  calculatePeak: (xyRatio, threshold) ->
    # @_smoothListに対して計算を行うので、事前にsmoothingを実行している必要がある
    if @_smoothList.length < 1
      return

    preIncline = (@_smoothList[1].y - @_smoothList[0].y) / ((@_smoothList[1].x - @_smoothList[0].x) * xyRatio)
    minIndex = 0
    maxIndex = 0
    @_peakList = []
    @_peakList.push({
      index: 0
      isMax: if preIncline>0 then false else true
      point: @_smoothList[0]
    })
    for index in [0 ... @_smoothList.length-1]
      if @_smoothList[minIndex].y > @_smoothList[index].y
        minIndex = index
      if @_smoothList[maxIndex].y < @_smoothList[index].y
        maxIndex = index

      incline = (@_smoothList[index+1].y - @_smoothList[index].y) / ((@_smoothList[index+1].x - @_smoothList[index].x) * xyRatio)
      if @_maxIncline.incline < incline
        @_maxIncline = {
          index : index
          incline : incline
          point : @_smoothList[index]
        }
      if @_minIncline.incline > incline
        @_minIncline = {
          index : index
          incline : incline
          point : @_smoothList[index]
        }

      if preIncline > threshold && incline < (-threshold)
        @_peakList.push({
          index: maxIndex
          isMax: true
          point: @_smoothList[maxIndex]
        })
        preIncline = incline
        minIndex = maxIndex
      else if preIncline < (-threshold) && incline > threshold
        @_peakList.push({
          index: minIndex
          isMax: false
          point: @_smoothList[minIndex]
        })
        preIncline = incline
        maxIndex = minIndex
      else if index == @_smoothList.length-2
        @_peakList.push({
          index: index+1
          isMax: if incline>0 then true else false
          point: @_smoothList[index+1]
        })

      if Math.abs(preIncline) < threshold && Math.abs(incline) > threshold
        preIncline = incline

    return

  calculateTotalGainAndDrop: ->
    # 事前にcalculateLocalMinMaxを実行している必要がある
    if @_peakList.length < 1
      return

    @_totalGain = 0
    @_totalDrop = 0
    preY = @_peakList[0].point.y
    @_peakList.forEach((peak, index) =>
      if index > 0
        if peak.isMax == true
          @_totalGain += (peak.point.y - preY)
        else
          @_totalDrop += (preY - peak.point.y)
        preY = peak.point.y
    )

  getAutoRange: (x) ->
    if @_peakList.length < 1
      return null

    result =
      start: 0
      end : 0
    @_peakList.some((peak, index) =>
      if peak.point.x > x || index == @_peakList.length - 1
        result.end = peak.point.x
        return true

      result.start = peak.point.x
      return false
    )

    return result

  setRange: (range) ->
    @_range = range

    if @_range.selected == false || @_smoothList.length == 0
      return

    startIndex = 0
    @_smoothList.some((point, index) =>
      if point.x >= @_range.start
        startIndex = index
        return true
      return false
    )
    @_range.start = @_smoothList[startIndex].x

    endIndex = @_smoothList.length - 1
    @_smoothList.slice().reverse().some((point, index) =>
      if point.x <= @_range.end
        endIndex = @_smoothList.length - index - 1
        return true
      return false
    )
    @_range.end = @_smoothList[endIndex].x

    @_range.width = @_range.end - @_range.start
    if @_range.width == 0
      @_range.min = @_smoothList[startIndex]
      @_range.max = @_smoothList[startIndex]
      @_range.gain = 0
      @_range.drop = 0
      @_range.maxIncline =
        index : startIndex
        incline : 0
        point : @_smoothList[startIndex]
      @_range.minIncline =
        index : startIndex
        incline : 0
        point : @_smoothList[startIndex]
      @_range.aveIncline = 0

module.exports = GraphLineData
