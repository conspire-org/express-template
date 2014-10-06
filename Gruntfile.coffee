path = require('path')

module.exports = (grunt) ->

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-express-server')
  
  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    # Compile CoffeeScript files
    coffee:
      compile:
        expand: true
        flatten: true
        cwd: "#{__dirname}/src/"
        src: [ '**/*.coffee' ]
        dest: 'app/'
        ext: '.js'

    # Grunt tasks, e.g. express, express:dev, express:dev:stop to control Express server
    express:
      options:
        script: 'app/app.js'
      dev: {}
      prod:
        options:
          node_env: 'production'

    # When source files change, compile; when compiled files change, restart server
    watch:
      coffee:
        files: 'src/**/*.coffee'
        tasks: [ 'coffee:compile' ]
      bower:
        files: 'bower_components/*/dist/*.js'
        tasks: [ 'bower:dev' ]
        options:
          event: [ 'all' ]
      express:
        files: [ 'app/**/*.js' ]
        tasks: [ 'express:dev' ]
        options:
          spawn: false
  
  # Default task(s).
  grunt.registerTask 'default', [ 'server' ]
  grunt.registerTask 'server', [ 'express:dev', 'watch' ]
  