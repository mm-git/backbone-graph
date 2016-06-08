#
# User: code house
# Date: 2016/06/03
#
require('./viewTest')
assert = require('assert')
CanvasView = require('../../src/View/canvasView')

describe 'CanvasView Class Test', ->
  it 'constructor test', ->
    canvas = new CanvasView({pos:[0, 0, 400, 600]})

    assert.equal(canvas.pos[0], 0)
    assert.equal(canvas.pos[1], 0)
    assert.equal(canvas.pos[2], 400)
    assert.equal(canvas.pos[3], 600)

    assert.equal(canvas.$el.prop('tagName'), 'CANVAS')
    assert.equal(canvas.$wrap.prop('tagName'), 'DIV')
    assert.equal(canvas.$el.parent()[0], canvas.$wrap[0])

    assert.equal(canvas.$wrap.css('overflow'), 'hidden')
    assert.equal(canvas.$wrap.css('position'), 'absolute')
    assert.equal(canvas.$wrap.css('left'), '0px')
    assert.equal(canvas.$wrap.css('top'), '0px')
    assert.equal(canvas.$wrap.css('width'), '400px')
    assert.equal(canvas.$wrap.css('height'), '600px')
    assert.equal(canvas.$wrap.css('webkitTouchCallout'), 'none')
    assert.equal(canvas.$wrap.css('webkitUserSelect'), 'none')
    assert.equal(canvas.$wrap.css('mozUserSelect'), 'none')
    assert.equal(canvas.$wrap.css('msUserSelect'), 'none')
    assert.equal(canvas.$wrap.css('userSelect'), 'none')
