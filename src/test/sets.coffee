should = require 'should'
math = require '../math'
sets = require '../sets'

a = new sets.Set [1..5]
b = new sets.Set [4..8]
c = new sets.Set [7..10]
d = new sets.Set [2..4]

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
        f = new sets.Set [1, 2, 3, 9, 10]
        g = new sets.Set [3, 4, 5, 6, 10]
        h = new sets.Set [6, 7, 8, 9, 10]
    
        math.sort(f.symmetric_difference(g, h).elements).should.eql [1, 2, 4, 5, 7, 8, 10]

    "sets have a subset of array-like methods": ->
        a_mod = a.filter (item) -> item < 4
        a_mod.length.should.equal 3

        b_mod = b.map (item) -> item * 2
        b_mod.elements.should.eql [8, 10, 12, 14, 16]

    "determine whether one set is a subset of another": ->
        a.is.subset_of(d).should.equal false
        d.is.subset_of(a).should.equal true
        a.is.subset_of(a).should.equal true

    "determine whether one set is a proper subset of another": ->
        a.is.proper_subset_of(a).should.equal false
        d.is.proper_subset_of(a).should.equal true

    "determine whether one set is a superset of another": ->
        d.is.superset_of(a).should.equal false
        a.is.superset_of(d).should.equal true
        a.is.superset_of(a).should.equal true

    "determine whether one set is a proper superset of another": ->
        a.is.proper_superset_of(a).should.equal false
        a.is.proper_superset_of(d).should.equal true
