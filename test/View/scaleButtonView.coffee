#
# User: code house
# Date: 2016/06/11
#
require('./viewTest')
assert = require('assert')
sinon = require('sinon')
ScaleButtonView = require('../../src/View/scaleButtonView.coffee')

describe 'ScaleButtonView Class Test', ->
  beforeEach ->
    @clickChecker =
      click: ->
    @click = sinon.spy @clickChecker, "click"

  afterEach: ->
    @click.restore()

  it 'constructor test', ->
    scaleButtonView = new ScaleButtonView({
      value: "+"
      click: => @clickChecker.click()
    })

    assert.equal(scaleButtonView._value, "+")
    assert.equal(typeof scaleButtonView._click, "function")

    assert.equal(scaleButtonView.$el.prop("tagName"), "BUTTON")
    assert.equal(scaleButtonView.$el[0].innerHTML, "+")
    assert.equal(scaleButtonView.$el[0].classList.contains("backbone_graph_scale_button"), true)
    assert.equal(scaleButtonView.$el[0].classList.contains("backbone_graph_scale_button_private"), true)

  it 'event test click', ->
    scaleButtonView = new ScaleButtonView({
      value: "+"
      click: => @clickChecker.click()
    })

    scaleButtonView.$el.trigger("click")
    assert.equal(@click.calledOnce, true)
