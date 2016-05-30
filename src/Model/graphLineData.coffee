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

  @property "totalGain",
    get: ->
      @_totalGain

  @property "totalDrop",
    get: ->
      @_totalDrop

  @property "isSmooth",
    get: ->
      return @_smoothList.length > 0

  clear: ->
    super()
    @_smoothList = []
    @_peakList = []
    @_totalGain = 0
    @_totalDrop = 0

  smooth: (interval, range) ->
    # interval 間隔でグラフデータをリサンプリングする
    xp = 0
    newPointList = []
    for index in [1 ... @_pointList.length]
      incline = (@_pointList[index].y - @_pointList[index-1].y) / (@_pointList[index].x - @_pointList[index-1].x)
      while xp < @_pointList[index].x
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

module.exports = GraphLineData
