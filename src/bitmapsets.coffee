#!/usr/bin/env coffee
 
# bitmapsets.coffee


# Class BitString essentially wraps a BigInt (n) to provide a bit string of a
# given length.
#
# args:
#   length: the number of bits in the bitstring.
#   n: the number to be interpreted as a bit string.
#
class BitString

  constructor: (@length, n) ->
    @n = BigInt(n)
    @too_big = BigInt(1) << BigInt(@length)
    @max_int = @too_big - BigInt(1)
    @pad_str = [0...@length].join('0')

  # Method toString() returns a string of 1's and 0's.  The string returned by
  # BitInt.toString(2) is padded on the left with 0's and the result is cropped
  # to the appropriate length.
  # 
  toString: =>
    (@too_big + @n).toString(2).slice(-@length)

  # Method copy() returns a copy of this bit string.
  # 
  copy: =>
    new BitString(@length, @n)

  # Method and() bitwise conjunction mutator.
  # 
  and: (bs) => @n &= bs.n

  # Method or() bitwise disjunction mutator.
  # 
  or: (bs) => @n |= bs.n

  # Method xor() bitwise xor mutator.
  # 
  xor: (bs) => @n ^= bs.n

  # Method not() bitwise complement mutator.
  # 
  not: => @n ^= @max_int

  # Method set(i) sets the i'th bit in @n to 1.
  # 
  set: (i) =>
    @n |= (BigInt(1) << BigInt(i))

  # Method test(i) returns true iff the i'th bit in @n is 1.
  # 
  test: (i) =>
    true and @get(i)

  # Method get(i) returns the i'th bit in @n.
  # 
  get: (i) =>
    @n & (BigInt(1) << BigInt(i))

  # Method clear(i) sets the i'th bit in @n to 0.
  # 
  clear: (i) =>
    @n &= ~(BigInt(1) << BigInt(i))

  # Method get_set_bits() returns an array of indexes for which the
  # corresponding bit in @n is 1.
  # 
  get_set_bits: =>
    set_bits = []
    for i in [0...@length]
      if @test(i)
        set_bits.push(i)
    return set_bits
  


# Class BitMap provides the 1-1 mapping from indexes to items.  The purpose
# of a BitMap instance is to provide a context for instance of class BitMapSet
# (see below).
# 
class BitMap

  constructor: (@items) ->
    @size = @items.length
    @too_big = BigInt(1) << BigInt(@size)
    @max_int = @too_big - BigInt(1)
    @range = [0...@size]
    @map = {}
    for i in @range
      @map[@items[i]] = i

  # Method get_item(index) returns item at index.
  # 
  get_item: (index) =>
    @items[index]

  # Method get_index(item) returns the index of item
  # 
  get_index: (item) =>
    @map[item]

  # Method empty_string() returns a string of 0's of the appropriate
  # length.
  # 
  empty_string: =>
    new BitString(@size, 0)

  # Method full_string() returns a string of 1's of the appropriate
  # length.
  # 
  full_string: =>
    new BitString(@size, @max_int)



# Class BitMapSet implements a bitmapped set with a context provided
# by @bitmap.
#
class BitMapSet

  constructor: (@bitmap, items = []) ->
    @bs = @bitmap.empty_string()
    for item in items
      @bs.set(@bitmap.get_index(item))

  get_items: =>
    @bs.get_set_bits().map(@bitmap.get_item)

  copy: =>
    s = new BitMapSet(@bitmap)
    s.bs = @bs.copy()
    return s

  add_items: (items) =>
    for item in items
      @bs.set(@bitmap.get_index(item))
    return this

  del_items: (items) =>
    for item in items
      @bs.clear(@bitmap.get_index(item))
    return this
    
  add_set: (s) =>
    @bs |= s.bs

  del_set: (s) =>
    @bs &= ~s.bs

  complement: =>
    _ = @copy()
    _.bs.not()
    return _
    
  union: (s) =>
    _ = @copy()
    _.bs.or(s.bs)
    return _

  intersect: (s) =>
    res = @copy()
    res.bs.and(s.bs)
    return res

  minus: (s) =>
    res = @copy()
    res.bs.and(s.bs.not())
    return res

  

exports.BitMap = BitMap
exports.BitMapSet = BitMapSet
