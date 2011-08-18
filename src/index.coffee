exports ?= window

exports.VERSION = '0.2.0'
exports.helpers = require './helpers'
exports.math = require './math'
exports.random = require './random'
exports.coordinates = require './coordinates'
exports.sets = require './sets'

exports.unpack = (submodules...) ->
    for name, value of exports
        if not submodules.length or (submodules.indexOf(name) > -1)
            window[name] = value
    undefined
