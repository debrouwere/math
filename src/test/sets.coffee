should = require 'should'
math = require '../math'
sets = require '../sets'

a = new sets.Set [1..5]
b = new sets.Set [4..8]
c = new sets.Set [7..10]

module.exports = 
    "compute the union of multiple sets": ->
        a.union(b, c).elements.should.eql [1..10]

    "intersection": ->
        a.intersection(b).elements.should.eql [4, 5]
        a.intersection(b, c).elements.should.eql []

    "difference": ->
        a.difference(b).elements.should.eql [1, 2, 3]
        a.difference(b, c).elements.should.eql [1, 2, 3]
        a.elements.should.eql [1..5]

    "symmetric difference": ->
        # the symmetric difference is every number that's in an odd amount of sets
        a = new sets.Set [1, 2, 3, 9, 10]
        b = new sets.Set [3, 4, 5, 6, 10]
        c = new sets.Set [6, 7, 8, 9, 10]
    
        math.sort(a.symmetric_difference(b, c).elements).should.eql [1, 2, 4, 5, 7, 8, 10]
