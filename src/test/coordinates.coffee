should = require 'should'
{polar, cartesian} = require '../coordinates'
{round, constants} = require '../math'

# Because conversions between coordinate systems are not exact
# (though they're usually accurate for more than ten decimals)
# these tests always compare rounded values.
module.exports = 
    "convert a polar coordinate to a cartesian coordinate": ->
        rt = new polar.Point 10, 30
        xy = rt.to cartesian.Point

        round(xy.x, 3).should.equal 1.543
        round(xy.y, 3).should.equal -9.880

    "convert a cartesian coordinate to a polar coordinate": ->
        xy = new cartesian.Point 20, 30
        rt = xy.to polar.Point

        round(rt.r, 3).should.equal 36.056
        round(rt.theta, 3).should.equal 0.983

    "convert between coordinate systems": ->
        rt = new polar.Point 10, 0.5
        xy = rt.to cartesian.Point
        rt2 = xy.to polar.Point

        round(rt.r, 10).should.equal rt2.r
        round(rt.theta, 10).should.equal rt2.theta

    "work with both degrees and radians": ->
        rt = new polar.Point 10, degrees: 30
        round(rt.theta, 3).should.equal 0.524

        # One radian is equal to 180/pi degrees, 
        # thus pi radians should equal 180 degrees.
        rt = new polar.Point 10, radians: constants.PI
        round(rt.degrees, 3).should.equal 180
