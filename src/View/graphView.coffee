__ = require('underscore')
$ = require('jquery')
Backbone = require('backbone')
GraphData = require('../Model/graphData.coffee')
GraphDataCollection = require('../Model/graphDataCollection.coffee')
AxisData = require('../Model/axisData.coffee')
GraphLineView = require('./graphLineView.coffee')
GraphPointView = require('./graphPointView.coffee')
AxisView = require('./axisView.coffee')

class GraphView extends Backbone.View
  @ORIGIN_OFFSET_X : 40
  @ORIGIN_OFFSET_Y : 20
  @NUMBER_FONT_SIZE : 12

  tagName: "canvas"

  _graphOptions = ['_pos', '_xAxis', '_yAxis', '_axisColor']

  initialize: (options) ->
    __.extend(@, __.pick(options, _graphOptions))
    @render()

    @_axisData = new AxisData({
      _xAxis: @_xAxis
      _yAxis: @_yAxis
    })
    @_axisView = new AxisView({
      el: @$el
      model: @_axisData
      _axisColor: @_axisColor
    })
    @_subView = @collection.map((model) =>
      subView = null
      switch model.type
        when GraphData.TYPE.LINE
          subView = new GraphLineView({
            el: @$el
            model: model
            _axis: @_axisData
          })
        when GraphData.TYPE.POINT
          subView = new GraphPointView({
            el: @$el
            model: model
            _axis: @_axisData
          })
      return subView
    )

    @listenTo(@collection, GraphDataCollection.EVENT_GRAPHDATA_CHANGED, (collection) =>
      @_axisData.setMaximum(collection.xMax, collection.yMax)
    )

  render: ->
    @$el
    .position(@_pos)
    @$el[0].width = @_pos[2]
    @$el[0].height = @_pos[3]

    @

module.exports = GraphView
