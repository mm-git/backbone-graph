#
# User: code house
# Date: 2016/06/11
#
require('./viewTest')
assert = require('assert')
ScaleData = require('../../src/Model/scaleData')
ScaleNumberView = require('../../src/View/scaleNumberView.coffee')

describe 'ScaleNumberView Class Test', ->
  beforeEach ->
    @xScaleData = new ScaleData({title: "X"})
    @scaleNumberView = new ScaleNumberView({
      model: @xScaleData
    })

  it 'constructor test', ->
    assert.equal(@scaleNumberView.$el.prop("tagName"), "INPUT")
    assert.equal(@scaleNumberView.$el[0].value, "X : 100%")
    assert.equal(@scaleNumberView.$el[0].classList.contains("backbone_graph_scale_number"), true)
    assert.equal(@scaleNumberView.$el[0].classList.contains("backbone_graph_scale_number_private"), true)

  it 'event test model:change', ->
    @xScaleData.scale = 200
    assert.equal(@scaleNumberView.$el[0].value, "X : 200%")
