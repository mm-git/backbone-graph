require('../Model/property')
__ = require('underscore')
Backbone = require('backbone')
HiddenView = require('./hiddenView')

class CanvasView extends Backbone.View
  tagName: "canvas"

  _canvasOptions = ['pos']

  # options = {pos:[x,y,w,h]}
  initialize: (options) ->
    __.extend(@, __.pick(options, _canvasOptions))
    @_wrap = new HiddenView({pos: @pos})
    @_wrap.$el.append(@$el)

  @property "$wrap",
    get: ->
      @_wrap.$el
    
    
module.exports = CanvasView