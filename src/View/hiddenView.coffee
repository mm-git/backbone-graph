Backbone = require('backbone')

class HiddenView extends Backbone.View
  tagName: "div"

  initialize: (options) ->
    @$el
    .css({
      overflow: "hidden"
      position: "absolute"
      left: options.pos[0]
      top: options.pos[1]
      width: options.pos[2]
      height: options.pos[3]
      webkitTouchCallout: "none"
      webkitUserSelect: "none"
      mozUserSelect: "none"
      msUserSelect: "none"
      userSelect: "none"
    })

module.exports = HiddenView