_ ?= require 'underscore'

# This `recurse` helper allows us to accept both arrays and 
# single values for every single function in this library.
#
# If we get an array, we simply apply the operation to each
# value in that array, saving people a mapping transformation.
recurse = (fn) ->
    (a, args...) ->
        if a.length?
            fn x, args... for x in a
        else
            fn a, args...

alias = (name, base) ->
    if base?
        -> math[base][name] arguments...
    else
        -> math[name] arguments...

module.exports = math = 
    constants:
        E:       Math.E
        LN2:     Math.LN2
        LN10:    Math.LN10
        LOG2E:   Math.LOG2E
        LOG10E:  Math.LOG10E
        PI:      Math.PI
        SQRT1_2: Math.SQRT1_2
        SQRT2:   Math.SQRT2

    random: Math.random

    # `noop` returns exactly the value that it has been given.
    # It stands for 'no operation'. A no-op is sometimes useful
    # when using a functional programming style.
    noop: recurse (a) -> a

    # Round a number up to n decimal places.
    # 
    # Note that you can also pass a negative amount of digits, in which case we'll 
    # round to the nearest tenth, hundredth et cetera for -1, -2 and so on.
    round: recurse (number, digits = 0) ->
        multiple = Math.pow 10, digits
        Math.round(number * multiple) / multiple

    # The absolute of a number is a number without any sign.
    # In practice, that makes it a positive number.
    abs: recurse (a) -> Math.abs a
    absolute: alias 'abs'

    # Convert any number, positive or negative, into a negative number.
    neg: recurse (a) -> -Math.abs a
    negative: alias 'neg'

    # Convert any number into its opposite. Positive numbers will become 
    # negative, and negative numbers will become positive.
    invert: recurse (a) -> -a

    # Give a number the sign of a second number. For example, if we give 3
    # the sign of -5, it becomes -3. If we give -12 the sign of 2, it
    # becomes 12.
    sign: recurse (a, b) ->
        a = math.absolute a
        if math.is_negative b
            math.negative a
        else
            a

    # Testing whether something is a positive number is as easy as `number >= 0`
    # but to aid in functional programming, a shortcut doesn't hurt.
    is_pos: recurse (a) -> a >= 0
    is_positive: alias 'is_pos'

    # Ditto `is_positive`.
    is_neg: recurse (a) -> a < 0
    is_negative: alias 'is_neg'

    # Find the minimal value of a sequence.
    min: Math.min
    minimum: alias 'min'

    # Find the maximal value of a sequence.
    max: Math.max
    maximum: alias 'max'

    # Round down a real value to an integer.
    floor: recurse Math.floor

    # Round up a real value to an integer.
    ceil: recurse Math.ceil
    ceiling: alias 'ceil'

    arc:
        cos: recurse Math.acos
        cosine: alias 'cos', 'arc'

        sin: recurse Math.asin
        sine: alias 'sin', 'arc'

        tan: recurse Math.atan
        tangent: alias 'tan', 'arc'

        tan2: recurse Math.atan2
        tangent_of_quotient: alias 'tan2', 'arc'

    cos: recurse Math.cos
    cosine: alias 'cos'

    sin: Math.sin
    sine: alias 'sin'

    tan: Math.tan
    tangent: alias 'tan'

    # Make the sum of a list.
    sum: ->
        _.reduce arguments, ((a, b) -> a+b), 0

    # Add a certain number to another number or to each number in a list.
    add: recurse (a, b) ->
        a + b

    # Subtract a certain number from another number or from each number in a list.        
    subtract: recurse (a, b) ->
        a - b

    # Divide a certain number by another number or divide each number in a list
    # by that number.
    quotient: recurse (a, b) ->
        a / b

    # Multiply a certain number by another number or multiply each number in a list
    # by that number.
    product: recurse (a, b) ->
        a * b

    # takes both positive and negative powers (nth roots)
    # inspired on a function written by Chris West
    # TODO: not sure if this is quite correct for everything you throw at it
    # TODO: make this work for fractions too, e.g 1/3 in addition to -3
    # (or make it clear that negative powers will be interpreted as roots)
    pow: recurse (x, n) ->
        # if we want an even (negative) root, 
        # we should negate our number and invert it at the end
        # to avoid NaN errors.        
        negate = n%2 is -1 and x < 0
        if negate
            x = Math.abs x

        if n < 0 then n = 1/Math.abs(n)
        power = Math.pow x, n

        if negate
            -power
        else
            power

    power: alias 'pow'

    root: recurse (a, b) ->
        math.power a, -b

    sq: recurse (a) -> math.power a, 2
    square: alias 'sq'

    cube: recurse (a) -> math.power a, 3

    sqrt: recurse Math.sqrt
    square_root: alias 'sqrt'

    factorial: recurse (n) ->
        return 1 unless n > 1
    
        f = 1        
        for i in [2..n]
            f *= i

        f

    ###
    - exponent e**x
    - log / ln
      see https://github.com/pr1001/MathPlus
    - not now, but would be appropriate: matrices, complex numbers, vectors, ...
      https://github.com/Kambfhase/m8
    ###
