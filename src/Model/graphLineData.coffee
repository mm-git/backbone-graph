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
    @_smoothStatistics = {}
    @_rangeStatistics = {
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

  # smooth
  #   max : GraphPoint
  #   min : GraphPoint
  #   gain : total gain
  #   drop : total drop
  #   incline:
  #     max : {incline(%), GraphPoint}
  #     min : {incline(%), GraphPoint}
  #     ave : incline(%)
  @property "smoothStatistics",
    get: ->
      @_smoothStatistics

  @property "isSmooth",
    get: ->
      @_smoothList.length != 0 && @_peakList.length != 0

  # range
  #   start : start X
  #   end : end X
  #   startIndex: index
  #   endIndex: index
  #   width : range x width
  #   min : GraphPoint
  #   max : GraphPoint
  #   gain : range gain
  #   drop : range drop
  #   incline:
  #     max : {incline(%), GraphPoint}
  #     min : {incline(%), GraphPoint}
  #     ave : incline(%)
  @property "rangeStatistics",
    get: ->
      @_rangeStatistics

  @property "isRangeSelected",
    get: ->
      @_rangeStatistics.selected

  clear: ->
    super()
    @_smoothList = []
    @_peakList = []
    @_smoothStatistics = {}
    @_rangeStatistics = {
      start: 0
      end: 0
      selected: false
    }

  smooth: (interval, range, xyRatio, threshold) ->
    @_reSampling(interval, range)
    @_peakList = @_calculatePeak(0, @_smoothList.length-1, xyRatio, threshold)

    @_smoothStatistics = {
      max : @_peakList.slice().sort((a, b) -> b.point.y - a.point.y)[0].point
      min : @_peakList.slice().sort((a, b) -> a.point.y - b.point.y)[0].point
    }
    __.extend(@_smoothStatistics, @_calculateTotalGainAndDrop(@_peakList))
    __.extend(@_smoothStatistics, @_calculateIncline(0, @_smoothList.length-1, xyRatio))

    @_xyRatio = xyRatio
    @_threshold = threshold

  unsmooth: ->
    @_smoothList = []
    @_peakList = []
    @_smoothStatistics = {}
    @_rangeStatistics = {
      start: @_rangeStatistics.start
      end: @_rangeStatistics.end
      selected: @_rangeStatistics.selected
    }

  _reSampling: (interval, range) ->
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

  _calculatePeak: (start, end, xyRatio, threshold) ->
    if @_smoothList.length < 1
      return []

    preIncline = (@_smoothList[start+1].y - @_smoothList[start].y) / ((@_smoothList[start+1].x - @_smoothList[start].x) * xyRatio)
    minIndex = start
    maxIndex = start
    peakList = []
    peakList.push({
      index: start
      isMax: if preIncline>0 then false else true
      point: @_smoothList[start]
    })
    for index in [start ... end]
      if @_smoothList[minIndex].y > @_smoothList[index].y
        minIndex = index
      if @_smoothList[maxIndex].y < @_smoothList[index].y
        maxIndex = index

      incline = (@_smoothList[index+1].y - @_smoothList[index].y) / ((@_smoothList[index+1].x - @_smoothList[index].x) * xyRatio)
      if preIncline > threshold && incline < (-threshold)
        peakList.push({
          index: maxIndex
          isMax: true
          point: @_smoothList[maxIndex]
        })
        preIncline = incline
        minIndex = maxIndex
      else if preIncline < (-threshold) && incline > threshold
        peakList.push({
          index: minIndex
          isMax: false
          point: @_smoothList[minIndex]
        })
        preIncline = incline
        maxIndex = minIndex
      else if index == end-1
        peakList.push({
          index: index+1
          isMax: if incline>0 then true else false
          point: @_smoothList[index+1]
        })

      if Math.abs(preIncline) < threshold && Math.abs(incline) > threshold
        preIncline = incline

    if peakList.length == 2 && peakList[0].isMax == peakList[1].isMax
      if peakList[0].point.y > peakList[1].point.y
        peakList[1].isMax = false
      if peakList[0].point.y < peakList[1].point.y
        peakList[1].isMax = true

    return peakList

  _calculateTotalGainAndDrop: (peakList)->
    if peakList.length < 1
      return

    total =
      gain : 0
      drop : 0
    preY = peakList[0].point.y
    peakList.forEach((peak, index) =>
      if index > 0
        if peak.isMax == true
          total.gain += (peak.point.y - preY)
        else
          total.drop += (preY - peak.point.y)
        preY = peak.point.y
    )
    return total

  _calculateIncline: (start, end, xyRatio) ->
    if @_smoothList.length < 1 || start > end - 1
      return {}

    inclineStatistics =
      max:
        incline: -100
      min:
        incline: 100
    totalIncline = 0

    for index in [start ... end]
      incline = (@_smoothList[index+1].y - @_smoothList[index].y) / ((@_smoothList[index+1].x - @_smoothList[index].x) * xyRatio) * 100
      if inclineStatistics.max.incline < incline
        inclineStatistics.max = {
          index : index
          incline : incline
          point : @_smoothList[index]
        }
      if inclineStatistics.min.incline > incline
        inclineStatistics.min = {
          index : index
          incline : incline
          point : @_smoothList[index]
        }
      totalIncline += incline

    inclineStatistics.ave = totalIncline / (end - start)

    return {incline : inclineStatistics}

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
    @_rangeStatistics = range

    if @_rangeStatistics.selected == false || @_smoothList.length == 0
      @trigger('changeSelection')
      return

    startIndex = 0
    @_smoothList.some((point, index) =>
      if point.x >= @_rangeStatistics.start
        startIndex = index
        return true
      return false
    )
    @_rangeStatistics.start = @_smoothList[startIndex].x
    @_rangeStatistics.startIndex = startIndex

    endIndex = @_smoothList.length - 1
    @_smoothList.slice().reverse().some((point, index) =>
      if point.x <= @_rangeStatistics.end
        endIndex = @_smoothList.length - index - 1
        return true
      return false
    )
    @_rangeStatistics.end = @_smoothList[endIndex].x
    @_rangeStatistics.endIndex = endIndex

    @_rangeStatistics.width = @_rangeStatistics.end - @_rangeStatistics.start
    if @_rangeStatistics.width == 0
      @_rangeStatistics.min = @_smoothList[startIndex]
      @_rangeStatistics.max = @_smoothList[startIndex]
      @_rangeStatistics.gain = 0
      @_rangeStatistics.drop = 0
    else
      peakList = @_calculatePeak(startIndex, endIndex, @_xyRatio, @_threshold)

      __.extend(@_rangeStatistics, {
        max : peakList.slice().sort((a, b) -> b.point.y - a.point.y)[0].point
        min : peakList.slice().sort((a, b) -> a.point.y - b.point.y)[0].point
      })
      __.extend(@_rangeStatistics, @_calculateTotalGainAndDrop(peakList))
      __.extend(@_rangeStatistics, @_calculateIncline(startIndex, endIndex, @_xyRatio))

    @trigger('changeSelection')

module.exports = GraphLineData
