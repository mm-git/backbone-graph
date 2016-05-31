Backbone = require('backbone')
require('./property')

class ScaleData extends Backbone.Model
  initialize: (options) ->
    @set('scale', 1)

  @property "title",
    get: ->
      @get('title')

  @property "scale",
    get: ->
      @get('scale')

module.exports = ScaleData


