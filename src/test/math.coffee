should = require 'should'
math = require '../math'

module.exports = 
    "round numbers up to x decimal places": ->
        expectations = [
            [9.234, 0, 9]
            [9.234, 1, 9.2]
            [9.234, 2, 9.23]
            [9.234, 3, 9.234]
            [9.234, 4, 9.234]
            [-0.33, 1, -0.3]
            [-0.37, 1, -0.4]
            ]

        for [number, digits, result] in expectations
            math.round(number, digits).should.equal result

    "calculate factorials": ->
        expectations = [
            [0, 1]
            [1, 1]
            [2, 2]
            [3, 6]
            [4, 24]
            [5, 120]
            ]

        for [number, expectation] in expectations
            math.factorial(number).should.equal expectation

    "multiply the numbers of a list by each other": ->
        math.factorial(5).should.equal math.multiply 1, 2, 3, 4, 5

    "find the greatest common divisor": ->
        expectations = [
            [[3,6,9], 3]
            [[1989,102,867], 51]
            [[[6, 11, 15], 3, 6], [3, 1, 3]]
            ]

        for [list, expectation] in expectations
            math.gcd(list...).should.eql expectation
        
    "find the lowest common multiple": ->
        expectations = [
            [[3,6,9], 18]
            [[4,8,16], 16]
            [[9,12], 36]
            ]

        for [list, expectation] in expectations
            math.lcm(list...).should.equal expectation
