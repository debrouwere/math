module.exports = 
    # The `recursive` helper allows us to accept both arrays and 
    # single values for every single function in this library.
    #
    # If we get an array, we simply apply the operation to each
    # value in that array, saving people a mapping transformation.
    recursive: (fn) ->
        recursive_fn = (a, args...) ->
            if a.constructor.name is 'Array'
                recursive_fn x, args... for x in a
            else
                fn a, args...

    # Similar to the `recursive` helper, but for functions that
    # take no parameters. For functions that work on positional
    # arguments, `normalize` simply converts arrays to
    # positional arguments when needed.
    normalize: (fn) ->
        ->
            if arguments[0].length?
                fn arguments[0]...
            else
                fn arguments...

    # Also similar to the `recursive` helper, but for functions that
    # (by their nature) are calculations or operations on lists 
    # instead of single numbers, like finding the maximum in a list.
    # `deep` allows these functions to batch-process lists of lists.
    deep: (fn) ->
        (list, args...) ->
            if list[0][0]?
                fn sublist, args... for sublist in list
            else
                fn list, args...

    # courtesy of underscore.js
    extend: (destination, sources...) ->
        for source in sources
            for prop of source
                if source[prop]? then destination[prop] = source[prop]

        destination

    copy: (obj) ->
        module.exports.extend {}, obj

    # create a function that just routes to another function
    route: (obj, method) ->
        ->
            @[obj][method] arguments...

# To support sets with custom objects rather than just numbers, 
# we need hashes that can have any object as their key, which JavaScript
# doesn't support out of the box. Hence our own hash implementation.
class module.exports.Hash
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
