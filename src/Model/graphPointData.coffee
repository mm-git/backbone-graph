__ = require('underscore')
GraphData = require('./graphData')

class GraphPointData extends GraphData
  @SHAPE:
    CIRCLE: 1
    DOWNWARD_TRIANGLE: 2
    TRIANGLE: 3
    SQUARE: 4
    DIAMOND: 5
    
  default:
    pointColor: "#ff3333"
    pointShape: GraphPointData.SHAPE.DOWNWARD_TRIANGLE

  initialize: (options) ->
    super(options)
    @set('type', GraphData.TYPE.POINT)

    @_attributeList = []
    
  @property "pointColor",
    get: ->
      @get('pointColor')

  @property "pointShape",
    get: ->
      @get('pointShape')
  
  @property "attributeList",
    get: ->
      @_attributeList

  clear: ->
    super()
    @_attributeList = []

  addPoint: (point, color, shape) ->
    super(point)
    @_attributeList.push({
      color: color || @pointColor
      shape: shape || @pointShape
    })      
      
  triggerEvent: (eventName, index, screenPos) ->
    @trigger(eventName, index, screenPos)

    
module.exports = GraphPointData
