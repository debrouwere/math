should = require 'should'
math = require '../math'
sets = require '../sets'

a = new sets.Set [1..5]
b = new sets.Set [4..8]
c = new sets.Set [7..10]

module.exports = 
    "compute the union of multiple sets": ->
        a.union(b, c).elements.should.eql [1..10]

    "compute the intersection of multiple sets": ->
        a.intersection(b).elements.should.eql [4, 5]
        a.intersection(b, c).elements.should.eql []

    "compute the difference of multiple sets": ->
        a.difference(b).elements.should.eql [1, 2, 3]
        a.difference(b, c).elements.should.eql [1, 2, 3]
        a.elements.should.eql [1..5]

    "compute the symmetric difference of multiple sets": ->
        # the symmetric difference is every number that's in an odd amount of sets
        d = new sets.Set [1, 2, 3, 9, 10]
        e = new sets.Set [3, 4, 5, 6, 10]
        f = new sets.Set [6, 7, 8, 9, 10]
    
        math.sort(d.symmetric_difference(e, f).elements).should.eql [1, 2, 4, 5, 7, 8, 10]

    "sets have a subset of array-like methods": ->
        a_mod = a.filter (item) -> item < 4
        a_mod.length.should.equal 3

        b_mod = b.map (item) -> item * 2
        b_mod.elements.should.eql [8, 10, 12, 14, 16]
