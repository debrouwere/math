# courtesy of underscore.js
extend = (destination, sources...) ->
    for source in sources
        for prop of source
            if source[prop]? then destination[prop] = source[prop]

    destination

# To support sets with custom objects rather than just numbers, 
# we need hashes that can have any object as their key, which JavaScript
# doesn't support out of the box. Hence our own hash implementation.
class exports.Hash
    constructor: ->
        @keys = []
        @values = []

    index: (key) ->
        @keys.indexOf key

    items: ->
        [@keys[i], @values[i]] for i in [0...@keys.length]

    get: (key, default_value) ->
        i = @index key
        if i > -1
            @values[i]
        else
            default_value

    set: (key, value) ->
        i = @index key
        if i == -1
            @keys.push key
            @values.push value
        else
            @values[i] = value

    remove: (key) ->
        i = @index key
        if i
            @keys.splice i, 1
            @values.splice i, 1
        else
            throw new Error()

class Tester
    constructor: (set) ->
        @set = set

    # Sets are disjoint if and only if their intersection is the empty set.
    disjoint: ->

    subset: ->

    true_subset: ->

    superset: ->

    true_superset: ->

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
        @hash = new Hash()
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
        tally = new exports.Hash()
        
        for set in sets.concat [@]
            for element in set.elements
                tally.set element, tally.get(element, 0) + 1

        console.log tally

        for [element, count] in tally.items()
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
