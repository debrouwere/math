math = require './math'

class exports.Fraction
    constructor: (numerator, denominator, simplify = yes) ->
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
