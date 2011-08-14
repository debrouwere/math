math = require './math'

module.exports = random = 
    random: math.random

    float: (start, stop) ->
        start + Math.random() * (start - stop)

    # According to Mozilla, using `Math.round` to generate pseudo-random
    # integers would lead to a non-uniform distribution. They advise 
    # using `Math.floor` instead, which is what we do.
    integer: (start, stop) ->
        start + Math.floor(Math.random() * (stop - start + 1))

    choice: (sequence) ->
        i = random.integer 0, sequence.length-1
        sequence[i]

    # Gives back a random number from a range. The arguments this
    # function supports are [start,] stop, [step].
    # By default, start = 0 and step = 1.
    range: ->
        r = math.range arguments...
        random.choice r

    # We can limit the shuffled (or permutated) sequence to k items
    # if we don't need the full sequence shuffled. This is a particularly 
    # useful optimization when grabbing a sample of a distribution.
    shuffle: (sequence, k) ->
        copied = sequence.slice()
        shuffled = []
        k ?= copied.length
        while k
            i = random.range copied.length
            shuffled.push copied[i]
            k--

        shuffled

    sample: (distribution, k, options) ->
        if options.replacement
            [0...k].map (i) -> random.choice(distribution)
        else
            random.shuffle(distribution, k)
