{recursive, extend, copy, route, Hash} = require './helpers'
math = require './math'

class Tester
    constructor: (set) ->
        @set = set

    # Sets are disjoint if and only if their intersection is the empty set.
    disjoint: (set) ->
        @set.intersection(set).length == 0

    subset_of: (set) ->
        # the supposed subset (`@set`) should be equally sized or smaller than
        # the set we compare with
        return no unless @set.length <= set.length

        _subset = math.sort(@set.elements)
        _set    = math.sort(set.elements)

        index = _set.indexOf _subset[0]
        return no if index is -1

        # we compare the part of the superset that is supposed to be the subset
        # with the supposed subset itself
        _set = _set.slice(index, index+_subset.length)        
        math.are.equal _subset, _set

    proper_subset_of: (set) ->
        @subset_of(set) and @set.length < set.length

    superset_of: (set) ->
        # the supposed superset (`@set`) should be at least as big as
        # the set we compare with
        return no unless @set.length >= set.length

        _superset = math.sort(@set.elements)
        _set      = math.sort(set.elements)

        index = _superset.indexOf _set[0]
        return no if index is -1

        _superset = _superset.slice(index, index+_set.length)

        console.log _superset
        console.log _set
        
        math.are.equal _superset, _set

    proper_superset_of: (set) ->
        @superset_of(set) and @set.length > set.length

# When working with a set, always add elements with `add` and 
# remove elements with `discard` or `remove`.
# Accessing the `elements` array is very useful for iterating
# over a set, but 
class exports.Set
    constructor: (list, comparators = {}) ->
        if typeof comparators is 'function'
            @comparators = default: comparators
        else
            @comparators = comparators
            if not comparators.default?
                @comparators.default = (a, b) -> a == b

        @is = new Tester @
        
        list ?= []
        @length = 0
        @elements = []
        @add element for element in list

    comparator_for: (element) ->
        @comparators[element.constructor.name] or @comparators.default

    contains: (element) ->
        for el in @elements
            if @comparator_for(element)(element, el) is true
                return yes
        return no

    add: (new_element) ->
        for element in @elements
            if @comparator_for(element)(new_element, element) is true
                return @
        @elements.push new_element
        @length += 1

        @

    discard: (element) ->
        @elements = @elements.filter (el) => @comparator_for(element)(element, el) is false
        @length -= 1

        @

    remove: (element) ->
        if @contains element
            @discard element
        else
            throw new Error "Element #{element} not in set."

    clear: ->
        @elements = []

    union: (sets...) ->
        un = Set::new sets..., @
        
        un.elements = @elements.slice()
        
        for set in sets
            for value in set.elements
                un = un.add(value)

        un 

    # inspired by underscore.js its _.intersection
    intersection: (sets...) ->
        sect = Set::new sets..., @
        sect.elements = @elements.filter (item) ->
            sets.every (set) ->
                set.elements.indexOf(item) > -1
        sect

    difference: (sets...) ->
        diff = Set::new sets..., @
        diff.elements = @elements.filter (item) ->
            sets.every (set) ->
                set.elements.indexOf(item) == -1
        diff

    # the symmetric difference of two sets is the set of elements which are in 
    # one of the sets but not in their intersection
    symmetric_difference: (sets...) ->       
        diff = Set::new sets..., @
        tally = new Hash()
        
        for set in sets.concat [@]
            for element in set.elements
                tally.set element, tally.get(element, 0) + 1

        for [element, count] in tally.items()
            if count % 2 == 1
                diff.add element
        
        diff

    # A subset of Array-like methods that make sense on Sets too
    forEach: route 'elements', 'forEach'
    
    every: route 'elements', 'every'
    
    some: route 'elements', 'some'

    filter: (callback) ->
        elements = @elements.filter callback
        new @constructor elements, copy @comparators

    # A mapped set is still a set, so if your mapped values
    # overlap, your set will shrink.
    #
    #    var mapped_set = set.map(function(a){ return 1; });
    #    mapped_set.length == 1;
    # 
    map: (callback) ->
        elements = @elements.map callback
        new @constructor elements, copy @comparators

exports.Set::new = (bases...) ->
    comparators = bases.map (set) -> set.comparators
    comparators = extend {}, comparators...
    new bases[0].constructor [], comparators

clone = (fn) ->
    ->
        set = new @constructor @elements, @comparators
        fn.apply set, arguments
        set

class exports.ImmutableSet extends exports.Set
    constructor: ->
        super arguments...
        @add = clone @add
        @discard = clone @discard
        @clear = clone @clear

class exports.NumericSet extends exports.Set
    constructor: (list) ->
        list = list.map (element) -> parseFloat element
        super list

class exports.ImmutableNumericSet extends exports.ImmutableSet
    constructor: (list) ->
        list = list.map (element) -> parseFloat element
        super list
