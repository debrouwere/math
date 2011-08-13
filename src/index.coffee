exports ?= window

exports.VERSION = '0.2.0'
exports.math = require './math'
exports.random = require './random'

exports.unpack = ->
    for name, value of exports
        window[name] = value
