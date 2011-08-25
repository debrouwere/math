should = require 'should'
{Fraction} = require '../fractions'

a = new Fraction 1, 3
b = new Fraction 1, 6
c = new Fraction 2, 6
d = new Fraction 4, 2
e = new Fraction 1, 2

module.exports = 
    "normalize the denominator of a bunch of fractions": ->
        [f, g] = Fraction.normalize a, b
        f.numerator.should.equal 2
        g.numerator.should.equal 1
        f.denominator.should.equal 6
        f.denominator.should.equal g.denominator

    "add a fraction to another fraction": ->
        f = Fraction.add a, b
        f.numerator.should.equal 1
        f.denominator.should.equal 2

    "multiply fractions": ->
        f = Fraction.multiply a, b
        g = Fraction.multiply d, e

        f.numerator.should.equal 1
        f.denominator.should.equal 18
        g.numerator.should.equal 1
        g.denominator.should.equal 1

    "work together with real numbers": ->
        (a*3).should.equal 1
