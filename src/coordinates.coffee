{convert, square, square_root, arc, sine, cosine} = require './math'

# we include degrees/radians conversions in this submodule as well, 
# for convenience's sake
exports.cartesian = {}
exports.polar = {}
exports.convert = convert

class exports.cartesian.Point
    constructor: (@x, @y) ->

    move: (x, y) ->
        new Point @x + x, @y + y

    to: (system) ->
        unless system is exports.polar.Point
            throw new Error "Can only convert to polar coordinates."

        r = square_root square(@y) + square(@x)
        theta = arc.tangent_of_quotient @y, @x

        new exports.polar.Point r, theta 

class exports.polar.Point
    # *r* is the radial coordinate, also known as radius
    # *theta* is the angular coordinate, also known as polar angle or azimuth
    # 
    # polar.Point accepts both radians and degrees for its angular coordinate, 
    # though its internal calculations are entirely radian-based, and if you 
    # pass a theta value without defining its unit, radians will be assumed.
    #
    #     new polar.Point(10, {radians: 0.5}) == new polar.Point(10, 0.5)
    #
    #     new polar.Point(10, degrees:30)
    constructor: (@r, theta) ->
        if typeof theta isnt 'number'
            if theta.degrees
                @degrees = theta.degrees
                @theta = convert.radians theta.degrees
            else if theta.radians
                @theta = theta.radians
            else
                throw new Error "You should pass an angular coordinate in radians or degrees."
        else
            @theta = theta

        # Purely for informational purposes, we'll convert theta into degrees.
        @degrees ?= convert.degrees @theta
        @normalized_degrees = @degrees % 360

    to: (system, options) ->
        unless system is exports.cartesian.Point
            throw new Error "Can only convert to cartesian coordinates."
    
        x = @r * cosine @theta
        y = @r * sine @theta

        point = new exports.cartesian.Point x, y

        # When visualizing points in a polar coordinate system, 
        # we often want the pole to be at the center of our 
        # cartesian grid. You'd do so as follows: 
        #
        #     point.to(cartesian.Point, {center:[grid.width/2, grid.height/2})
        #
        if options?.center
            points = point.move options.center...

        point
