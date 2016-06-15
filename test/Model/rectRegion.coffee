#
# User: code house
# Date: 2016/06/14
#
assert = require('assert')

RectRegion = require('../../src/Model/rectRegion')

describe 'RectRegion Class Test', ->
  it 'constructor test', ->
    rect = new RectRegion(0, 10, 100, 200)

    assert.equal(rect.minX, 0)
    assert.equal(rect.minY, 10)
    assert.equal(rect.maxX, 100)
    assert.equal(rect.maxY, 200)

  it 'constructor test(exception)', ->
    try
      rect = new RectRegion(null, null, null, null)
      assert(false)
    catch e
      assert.equal(e, "All parameters are null")

    try
      rect = new RectRegion(100, null, 10, null)
      assert(false)
    catch e
      assert.equal(e, "minX muse be less than maxX")

    try
      rect = new RectRegion(null, 100, null, 10)
      assert(false)
    catch e
      assert.equal(e, "minY muse be less than maxY")

  it 'set properties', ->
    rect = new RectRegion(0, 10, 100, 200)

    rect.minX = 100
    assert.equal(rect.minX, 100)
    try
      rect.minX = 101
      assert(false)
    catch e
      assert.equal(e, "minX muse be less than maxX")
    assert.equal(rect.minX, 100)
    rect.minX = 0

    rect.maxX = 0
    assert.equal(rect.maxX, 0)
    try
      rect.maxX = -1
      assert(false)
    catch e
      assert.equal(e, "minX muse be less than maxX")
    assert.equal(rect.maxX, 0)
    rect.maxX = 10

    rect.minY = 200
    assert.equal(rect.minY, 200)
    try
      rect.minY = 201
      assert(false)
    catch e
      assert.equal(e, "minY muse be less than maxY")
    assert.equal(rect.minY, 200)
    rect.minY = 10

    rect.maxY = 10
    assert.equal(rect.maxY, 10)
    try
      rect.maxY = 9
      assert(false)
    catch e
      assert.equal(e, "minY muse be less than maxY")
    assert.equal(rect.maxY, 10)
    rect.maxY = 200

  it 'function test isInside()', ->
    testCase = [
      #minX  minY  maxX  maxY  x     y     result
      [100,  null, null, null, 99,   null, false]
      [100,  null, null, null, 100,  null, true]
      [100,  null, null, null, 101,  null, true]
      [100,  200,  null, null, 99,   199,  false]
      [100,  200,  null, null, 99,   200,  false]
      [100,  200,  null, null, 99,   201,  false]
      [100,  200,  null, null, 100,  199,  false]
      [100,  200,  null, null, 100,  200,  true]
      [100,  200,  null, null, 100,  201,  true]
      [100,  200,  null, null, 101,  199,  false]
      [100,  200,  null, null, 101,  200,  true]
      [100,  200,  null, null, 101,  201,  true]
      [null, 200,  null, null, null, 199,  false]
      [null, 200,  null, null, null, 200,  true]
      [null, 200,  null, null, null, 201,  true]
      [null, 200,  300,  null, 299,  199,  false]
      [null, 200,  300,  null, 299,  200,  true]
      [null, 200,  300,  null, 299,  201,  true]
      [null, 200,  300,  null, 300,  199,  false]
      [null, 200,  300,  null, 300,  200,  true]
      [null, 200,  300,  null, 300,  201,  true]
      [null, 200,  300,  null, 301,  199,  false]
      [null, 200,  300,  null, 301,  200,  false]
      [null, 200,  300,  null, 301,  201,  false]
      [null, null, 300,  null, 299,  null, true]
      [null, null, 300,  null, 300,  null, true]
      [null, null, 300,  null, 301,  null, false]
      [null, null, 300,  400,  299,  399,  true]
      [null, null, 300,  400,  299,  400,  true]
      [null, null, 300,  400,  299,  401,  false]
      [null, null, 300,  400,  300,  399,  true]
      [null, null, 300,  400,  300,  400,  true]
      [null, null, 300,  400,  300,  401,  false]
      [null, null, 300,  400,  301,  399,  false]
      [null, null, 300,  400,  301,  400,  false]
      [null, null, 300,  400,  301,  401,  false]
      [null, null, null, 400,  null, 399,  true]
      [null, null, null, 400,  null, 400,  true]
      [null, null, null, 400,  null, 401,  false]
      [100,  null, null, 400,  99,   399,  false]
      [100,  null, null, 400,  99,   400,  false]
      [100,  null, null, 400,  99,   401,  false]
      [100,  null, null, 400,  100,  399,  true]
      [100,  null, null, 400,  100,  400,  true]
      [100,  null, null, 400,  100,  401,  false]
      [100,  null, null, 400,  101,  399,  true]
      [100,  null, null, 400,  101,  400,  true]
      [100,  null, null, 400,  101,  401,  false]
      [100,  null, 300,  null, 99,   null, false]
      [100,  null, 300,  null, 100,  null, true]
      [100,  null, 300,  null, 101,  null, true]
      [100,  null, 300,  null, 299,  null, true]
      [100,  null, 300,  null, 300,  null, true]
      [100,  null, 300,  null, 301,  null, false]
      [null, 200,  null, 400,  null, 199,  false]
      [null, 200,  null, 400,  null, 200,  true]
      [null, 200,  null, 400,  null, 201,  true]
      [null, 200,  null, 400,  null, 399,  true]
      [null, 200,  null, 400,  null, 400,  true]
      [null, 200,  null, 400,  null, 401,  false]
      [100,  200,  300,  null, 99,   199,  false]
      [100,  200,  300,  null, 99,   200,  false]
      [100,  200,  300,  null, 99,   201,  false]
      [100,  200,  300,  null, 100,  199,  false]
      [100,  200,  300,  null, 100,  200,  true]
      [100,  200,  300,  null, 100,  201,  true]
      [100,  200,  300,  null, 101,  199,  false]
      [100,  200,  300,  null, 101,  200,  true]
      [100,  200,  300,  null, 101,  201,  true]
      [100,  200,  300,  null, 299,  199,  false]
      [100,  200,  300,  null, 299,  200,  true]
      [100,  200,  300,  null, 299,  201,  true]
      [100,  200,  300,  null, 300,  199,  false]
      [100,  200,  300,  null, 300,  200,  true]
      [100,  200,  300,  null, 300,  201,  true]
      [100,  200,  300,  null, 301,  199,  false]
      [100,  200,  300,  null, 301,  200,  false]
      [100,  200,  300,  null, 301,  201,  false]
      [null, 200,  300,  400,  299,  199,  false]
      [null, 200,  300,  400,  299,  200,  true]
      [null, 200,  300,  400,  299,  201,  true]
      [null, 200,  300,  400,  299,  399,  true]
      [null, 200,  300,  400,  299,  400,  true]
      [null, 200,  300,  400,  299,  401,  false]
      [null, 200,  300,  400,  300,  199,  false]
      [null, 200,  300,  400,  300,  200,  true]
      [null, 200,  300,  400,  300,  201,  true]
      [null, 200,  300,  400,  300,  399,  true]
      [null, 200,  300,  400,  300,  400,  true]
      [null, 200,  300,  400,  300,  401,  false]
      [null, 200,  300,  400,  301,  199,  false]
      [null, 200,  300,  400,  301,  200,  false]
      [null, 200,  300,  400,  301,  201,  false]
      [null, 200,  300,  400,  301,  399,  false]
      [null, 200,  300,  400,  301,  400,  false]
      [null, 200,  300,  400,  301,  401,  false]
      [100,  null, 300,  400,  99,   399,  false]
      [100,  null, 300,  400,  99,   400,  false]
      [100,  null, 300,  400,  99,   401,  false]
      [100,  null, 300,  400,  100,  399,  true]
      [100,  null, 300,  400,  100,  400,  true]
      [100,  null, 300,  400,  100,  401,  false]
      [100,  null, 300,  400,  101,  399,  true]
      [100,  null, 300,  400,  101,  400,  true]
      [100,  null, 300,  400,  101,  401,  false]
      [100,  null, 300,  400,  299,  399,  true]
      [100,  null, 300,  400,  299,  400,  true]
      [100,  null, 300,  400,  299,  401,  false]
      [100,  null, 300,  400,  300,  399,  true]
      [100,  null, 300,  400,  300,  400,  true]
      [100,  null, 300,  400,  300,  401,  false]
      [100,  null, 300,  400,  301,  399,  false]
      [100,  null, 300,  400,  301,  400,  false]
      [100,  null, 300,  400,  301,  401,  false]
      [100,  200,  null, 400,  99,   199,  false]
      [100,  200,  null, 400,  99,   200,  false]
      [100,  200,  null, 400,  99,   201,  false]
      [100,  200,  null, 400,  99,   399,  false]
      [100,  200,  null, 400,  99,   400,  false]
      [100,  200,  null, 400,  99,   401,  false]
      [100,  200,  null, 400,  100,  199,  false]
      [100,  200,  null, 400,  100,  200,  true]
      [100,  200,  null, 400,  100,  201,  true]
      [100,  200,  null, 400,  100,  399,  true]
      [100,  200,  null, 400,  100,  400,  true]
      [100,  200,  null, 400,  100,  401,  false]
      [100,  200,  null, 400,  101,  199,  false]
      [100,  200,  null, 400,  101,  200,  true]
      [100,  200,  null, 400,  101,  201,  true]
      [100,  200,  null, 400,  101,  399,  true]
      [100,  200,  null, 400,  101,  400,  true]
      [100,  200,  null, 400,  101,  401,  false]
      [100,  200,  300,  400,  99,   199,  false]
      [100,  200,  300,  400,  99,   200,  false]
      [100,  200,  300,  400,  99,   201,  false]
      [100,  200,  300,  400,  99,   399,  false]
      [100,  200,  300,  400,  99,   400,  false]
      [100,  200,  300,  400,  99,   401,  false]
      [100,  200,  300,  400,  100,  199,  false]
      [100,  200,  300,  400,  100,  200,  true]
      [100,  200,  300,  400,  100,  201,  true]
      [100,  200,  300,  400,  100,  399,  true]
      [100,  200,  300,  400,  100,  400,  true]
      [100,  200,  300,  400,  100,  401,  false]
      [100,  200,  300,  400,  101,  199,  false]
      [100,  200,  300,  400,  101,  200,  true]
      [100,  200,  300,  400,  101,  201,  true]
      [100,  200,  300,  400,  101,  399,  true]
      [100,  200,  300,  400,  101,  400,  true]
      [100,  200,  300,  400,  101,  401,  false]
      [100,  200,  300,  400,  299,  199,  false]
      [100,  200,  300,  400,  299,  200,  true]
      [100,  200,  300,  400,  299,  201,  true]
      [100,  200,  300,  400,  299,  399,  true]
      [100,  200,  300,  400,  299,  400,  true]
      [100,  200,  300,  400,  299,  401,  false]
      [100,  200,  300,  400,  300,  199,  false]
      [100,  200,  300,  400,  300,  200,  true]
      [100,  200,  300,  400,  300,  201,  true]
      [100,  200,  300,  400,  300,  399,  true]
      [100,  200,  300,  400,  300,  400,  true]
      [100,  200,  300,  400,  300,  401,  false]
      [100,  200,  300,  400,  301,  199,  false]
      [100,  200,  300,  400,  301,  200,  false]
      [100,  200,  300,  400,  301,  201,  false]
      [100,  200,  300,  400,  301,  399,  false]
      [100,  200,  300,  400,  301,  400,  false]
      [100,  200,  300,  400,  301,  401,  false]
    ]

    testCase.forEach((test, index) ->
      #console.log "test case=#{index}"
      rect = new RectRegion(test[0], test[1], test[2], test[3])
      assert.equal(rect.isInside(test[4], test[5]), test[6])
    )
