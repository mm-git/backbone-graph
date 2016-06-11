#
# User: code house
# Date: 2016/06/11
#
require('./viewTest')
assert = require('assert')
ScaleData = require('../../src/Model/scaleData')
ScaleChangeView = require('../../src/View/scaleChangeView.coffee')


describe 'ScaleChangeView Class Test', ->
  beforeEach ->
    @xScaleData = new ScaleData({title: "X"})
    @scaleChangeView = new ScaleChangeView({
      model: @xScaleData
    })

  it 'constructor test', ->
    assert.equal(@scaleChangeView.$el.prop("tagName"), "DIV")
    assert.equal(@scaleChangeView.$el[0].classList.contains("backbone_graph_scale"), true)
    assert.equal(@scaleChangeView.$el[0].classList.contains("backbone_graph_scale_private"), true)

    assert.equal(@scaleChangeView.$el[0].childNodes.length, 3)
    assert.equal(@scaleChangeView.$el[0].childNodes[0].tagName, "BUTTON")
    assert.equal(@scaleChangeView.$el[0].childNodes[1].tagName, "INPUT")
    assert.equal(@scaleChangeView.$el[0].childNodes[2].tagName, "BUTTON")

  it 'event test click', ->
    $(@scaleChangeView.$el[0].childNodes[2]).trigger('click')
    assert.equal(@xScaleData.scale, 150)
    assert.equal($(@scaleChangeView.$el[0].childNodes[1])[0].value, "X : 150%")

    $(@scaleChangeView.$el[0].childNodes[0]).trigger('click')
    assert.equal(@xScaleData.scale, 100)
    assert.equal($(@scaleChangeView.$el[0].childNodes[1])[0].value, "X : 100%")
