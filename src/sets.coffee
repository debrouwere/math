# courtesy of underscore.js
extend = (destination, sources...) ->
    for source in sources
        for prop of source
            if source[prop]? then destination[prop] = source[prop]

    destination

class Tester
    constructor: (set) ->
        @set = set

    # Sets are disjoint if and only if their intersection is the empty set.
    disjoint: ->

    subset: ->

    true_subset: ->

    superset: ->

    true_superset: ->

# Although it is often more efficient to implement sets in terms of
# hash tables, storing a set as an array is more convenient and easier
# considering JavaScript's lack of support for 
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

        @

    discard: (element) ->
        @elements = @elements.filter (el) => @comparator_for(element)(element, el) is false

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
        # note that, because of limitations in JavaScript hashes, this won't
        # work for complex objects (unless we'd ask for a hash function in 
        # addition to comparators)
        tally = {}
        
        for set in sets.concat [@]
            for element in set.elements
                tally[element] ?= 0
                tally[element] += 1

        for element, count of tally
            if count % 2 == 1
                diff.add element
        
        diff

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
