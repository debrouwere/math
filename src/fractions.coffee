math = require './math'

class exports.Fraction
    constructor: (numerator, denominator, simplify = yes) ->
        if not denominator?
            if numerator % 1 != 0
                return exports.Fraction.from_real numerator
            else
                denominator = 1
    
        common_denominator = math.gcd numerator, denominator
        if common_denominator > 1
            @irreducible = no
        else
            @irreducible = yes
    
        if simplify
            @numerator = numerator / common_denominator
            @denominator = denominator / common_denominator
            @irreducible = yes
        else
            @numerator = numerator
            @denominator = denominator

    valueOf: ->
        @numerator / @denominator

exports.Fraction.from_real = (number) ->
    # Reduces any number to a number lower than or equal to 0.5
    # (which we need to find the denominator).
    # The "or 1" is to accomodate fractions with an invisible
    # denominator, that is, a denominator that's 1, for example
    # in fractions like 12/1
    base = math.sign(math.round(number) - number or 1, number)
    # We want to be accurate up to 12 decimal places, but have
    # to account for the fact that representing true fractions
    # as floats always brings some amount of imprecision.
    numerator = math.round number/base, 12
    denominator = math.round 1/base, 12

    # At this point, we've kind of semi-fractionalized our real
    # number, for example from 0.6 into 1.5 / 2.5, but we 
    # still have to multiply both numerator and denominator until
    # we've got nice round integers.
    # 
    # We can do so by finding the reciprocal of our denominator 
    # modulo 1. It's easier to see why this works when you 
    # calculate it than by explaining it, but in effect what we're
    # doing is finding the lowest number that will turn a
    # decimal number into an integer. That's our multiplier.
    # 
    # The "or 1" is because we can't divide by zero.
    multiplier = 1 / (denominator % 1 or 1)
    numerator *= multiplier
    denominator *= multiplier

    if numerator % 1 == denominator % 1 == 0
        new exports.Fraction numerator, denominator
    else
        throw new Error "#{number} can't be converted to a fraction."

exports.Fraction.normalize = (fractions...) ->
    denominators = fractions.map (fraction) -> fraction.denominator
    normalized_denominator = math.lcm denominators...
    
    fractions.map (fraction) ->
        numerator = fraction.numerator * normalized_denominator / fraction.denominator
        new exports.Fraction numerator, normalized_denominator, no

exports.Fraction.add = (fractions...) ->
    fractions = exports.Fraction.normalize fractions...
    numerators = fractions.map (fraction) -> fraction.numerator
    numerator = math.add numerators...

    new exports.Fraction numerator, fractions[0].denominator

exports.Fraction.multiply = (fractions...) ->
    fractions = exports.Fraction.normalize fractions...
    numerators = fractions.map (fraction) -> fraction.numerator
    denominators = fractions.map (fraction) -> fraction.denominator
    numerator = math.multiply numerators...
    denominator = math.multiply denominators...

    new exports.Fraction numerator, denominator
