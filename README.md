
## Bit Mapped Sets

### Introduction

It has long been common to represent finite sets as strings of bits
which can be stored and manipulated using bitwise logical operators
which are generally available and which can be executed with a single
machine instruction.  An architecture with a 64-bit word size can
perform a set operation (intersection, union, difference, complement
etc.) 64 elements at a time.  This is not new, but what I've tried to
do here is provide a high level abstraction that provides a programmer
a tool to create and use families of sets which share a common bitmap,
i.e. a bijection from indexes to elements. These sets can then be
operated on very efficiently and at a high level of abstraction,
sparing the programmer the details of converting to/from the bit
string representation of the sets.

The key to the set abstraction is that all the sets in a family
are defined with reference to a fixed finite universe of elements, so
all the sets are subsets of this universal set.  Once the universe is
defined, a 1-1 mapping of its elements to indexes is created. This way
each set is mapped to a distinct string of bits, the length of which
is the size of the universe.

### Design

I've taken an object oriented approach to the design of these bit
mapped sets.  Two classes are defined: BitMap and BitMapSet.  A BitMap
(i.e. an instance of class BitMap) provides the universe and is
constructed from a list (Javascript array) of items.  Then BitMapSets
(instances of class BitMapSet) are constructed with reference to the
BitMap.  It's the reference to the common BitMap that allows the sets
to be manipulated in a consistent way.

Methods are provided to add/remove items (always from the universal
set, of course) to/from a set, to test membership of an item in a set,
and to retrieve an array containing the elements of a set.  These
methods all require using the BitMap to get/set/test the apropriate
bits of the bit string.

Methods are also provide to perform set union, intersection, complement and
difference.  These methods are provided in both mutator and operator form and
utilize the underlying bit-wise operators to achieve their ends.

### Quick Start

This project requires the following programs to build from scratch:

 - [`nodejs`](https://nodejs.org/en/)
 - [`npm`](https://www.npmjs.com/)

If these requirements are satisfied, you can download and build 
the project as follows:

```
$ git clone https://github.com/alcarruth/bitmapsets
$ cd bitmapsets
$ npm install
$ npm run build
```

This will build the project files and install them in the `lib`
subdirectory.

```
$ node src/tools/serve.js
```


### Project Overview and Usage


### CoffeeScript

This site was built using [CoffeeScript](http://coffeescript.org/),
both for generation of the javascript and for the build process.  Care
was taken to ensure that meaningful comments survived the compilation
process intact and that the produced JavaScript satisfied the style
requirements and JSHint.

It is my belief that this produced much more comprehensible code than
using JavaScript straight away.  CoffeeScript offers a clean object
oriented syntax that encourages thinking about the problem at hand at
a more abstract level, while avoiding some of the pitfalls of a pure
JavaScript approach.

In particular, I believe the use of an unbound `this` reference is bad
mojo. If you have a look at the CoffeeScript in this project, note
that while constructors and a few simple functions are defined using
the single arrow (`->`) all of the method definitions are defined
using the double arrow (`=>`) which binds `this` to the instance of
the class being defined.

The binding of a function to its data structure is one of the major
tenets of object-oriented programming.  It is the difference between a
function and a method.

### Architecture



### Build Tools


### License

The code in this repository is licensed under the [ISC](https://opensource.org/licenses/ISC) license of the Open Source Initiative.
