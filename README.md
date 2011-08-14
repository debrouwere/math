Math is a better math library for JavaScript. Everything that's available under your 
good ol' Math object is available under the `math` prefix as well, but so much more 
too.

Math is focused on arithmetic and other simple operations on numbers, like finding the 
greatest common divisor, rounding numbers, generating random numbers and converting
between polar and cartesian coordinates. Stuff that's useful for everyday calculations.
Don't expect something like [NumPy or SciPy](http://www.scipy.org/) — you'd be disappointed.

Some care has been taken to make sure that operations are never in-place: we don't
change existing data structures but always return calculations as a new number, in 
a new array or other structure.

Aditionally, most functions can batch-process lists in addition to processing single values, 
which makes it easy to e.g. round an entire sequence of numbers without having to go through
a mapping step.

Math is mostly backwards-compatible with JavaScript's built-in Math library: replace `Math.pow`
with `math.pow`, `Math.cos` with `math.cos` and so on, and everything will keep working. There
are two exceptions to that rule: 

  * Inverse trigonometric functions like `arcsin` and `arctan` are available under
    the `arc` namespace. Thus, to get the arc sine of a number, use `math.arc.sin`
    or `math.arc.sine`.
  * All constants are under the `constants` namespace. Thus, `Math.PI` is equal to
    `math.constants.PI`.

Most functions have aliases. Thus, `math.arc.tan2` is also available as 
`math.arc.tangent_of_quotient`, `math.max` is also available as `math.maximum` and `math.log`
is also available as `math.logarithm` and`math.ln`. In some cases, writing the full names can 
make code more understandable, whereas in other cases it only causes clutter. Decide for yourself
which is more apt for your use-case.

You can use math in the browser and in node.js. The library is subdivided into the 
submodules `math` and `random`. If you just need one or the other, or just want
easier shortcuts, do

    // create a basic shortcut
    math = math.math;
    // this adds `math`, `random` and `coordinates` to the window object, 
    // allowing you to use e.g. `random.integer()` instead of
    // `math.random.integer()`
    math.unpack();
    // in node.js
    var math = require('math').math;

Or, in CoffeeScript:

    # in the browser
    {math, random} = math
    # in node.js
    {math, random} = require 'math'

Also take a look at these libraries: 

  * [underscore.js](https://github.com/documentcloud/underscore) contains 
    functional programming aids that are essential if you're manipulating
    big datasets.
  * [mathnetics](https://github.com/shanest/mathnetics), a mathematics library
    that makes it easy to handle sets, groups, vectors, matrices, planes and 
    more.
  * [m8](https://github.com/Kambfhase/m8), another interesting math library.
  * [MathPlus](https://github.com/pr1001/MathPlus) provides useful
    approximation functions for limits and derivatives.
  * [summa](https://github.com/stdbrouw/summa), a small library for descriptive
    statistics in JavaScript and CoffeeScript, which is built on this mathematics
    library.
