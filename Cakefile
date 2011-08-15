exec  = require('child_process').exec
fs    = require 'fs'
summa = require './src/index'

header = """
  /**
   * Math v#{summa.VERSION}
   * http://github.com/stdbrouw/math
   *
   * Copyright 2011, Stijn Debrouwere
   * Released under the MIT License
   */

"""

task 'clean', 'clean the build', ->
    exec 'rm -rf lib', -> console.log 'Cleaned ./lib'

task 'build', 'build the JavaScript source files', ->
    console.log 'Starting build'
    exec 'coffee -o lib -c src', ->
        console.log 'Build complete'

# heavily inspired by Jeremy Ashkenas' CoffeeScript build script
task 'build:browser', 'merge and uglify the code for usage in a browser environment', ->
    # order is important: we can't require anything that isn't loaded yet
    modules = ['helpers', 'math', 'random', 'sets', 'coordinates', 'index']
    
    code = ''
    
    for name in modules
        module = fs.readFileSync "lib/#{name}.js"
        code += """
            require['./#{name}'] = new function() {
                var module = {};
                var exports = this;
                #{module}
                for (var prop in module.exports) {
                    if (module.exports[prop] !== void 0) exports[prop] = module.exports[prop];
                }
            };
            """
    code = """
        this.math = function() {
            var modules = {};
            function require(path){ return require[path]; }
            #{code}
            return require['./index'];
        }();
        """
    
    unless process.env.MINIFY is 'false'
        {parser, uglify} = require 'uglify-js'
        code = uglify.gen_code uglify.ast_squeeze uglify.ast_mangle parser.parse code

    fs.writeFileSync 'math.min.js', header + code

task 'test', 'run the math test suite', ->
    exec 'expresso lib/test/*', (error, stdout, stderr) ->
        process.stderr.write stderr
