class Tester
    constructor: (set) ->
        @set = set

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
                return
        @elements.push new_element

        undefined

    discard: (element) ->
        @elements = @elements.filter (el) => @comparator_for(element)(element, el) is false  

    remove: (element) ->
        if @contains element
            @discard element
        else
            throw new Error "Element #{element} not in set."

    clear: ->
        @elements = []

    union: ->

    intersection: ->

    difference: ->

    symmetric_difference: ->

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
