#!/usr/bin/env coffee

# test.coffee

{ BitMap, BitMapSet } = require('./bitmapsets')

class Test

  constructor: (@size) ->
    @bitmap = new BitMap([0...@size])

  random_index: =>
    Math.floor(@size * Math.random())

  random_indexes: (density) =>
    size = Math.floor(@size * density)
    @random_index() for _ in [0...size]
    
  random_set: (density) =>
    new BitMapSet(@bitmap, @random_indexes(density))


if module.parent?
  if exports?
    exports.Test = Test
else
  test = new Test(40)
  console.log "Hi Al!"
  sets = (test.random_set(0.3) for _ in [0...10])
  console.log(s.get_items()) for s in sets
