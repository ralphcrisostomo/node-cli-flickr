'use strict'

gulp      = require('gulp')
clean     = require('gulp-clean')
template  = require('gulp-template')
conflict  = require('gulp-conflict')
debug     = require('gulp-debug')
rename    = require('gulp-rename')
inquirer  = require('inquirer')

dir =
  templates   : './gulp/templates'
  app         : './app/modules'
  test        : './test/unit/modules'



# Create task template for mixin
# ------------------------------
gulp.task 'template:module', (done) ->
  inquirer.prompt [
    type : 'list'
    name : 'action'
    message : 'Select an action :'
    choices :[  'Generate', 'Destroy']
  ,
    type    : 'input'
    name    : 'name'
    message : 'Module name :'
  ], (answers) ->

    filename = answers.name.toLowerCase()

    # Generate template
    # ------------------------------
    if answers.action is 'Generate'
      gulp.src "#{dir.templates}/module/module"
        .pipe template answers
        .pipe rename
          basename  : filename
          extname   : '.coffee'

        .pipe conflict "#{dir.app}"
        .pipe gulp.dest "#{dir.app}"

      gulp.src "#{dir.templates}/module/test"
        .pipe template answers
        .pipe rename
          basename  : filename
          suffix    : '.test'
          extname   : '.coffee'

        .pipe conflict "#{dir.test}"
        .pipe gulp.dest "#{dir.test}"
        .on 'end', ->
          done()

      # Destroy template
      # ------------------------------
    else
      gulp.src [
        "#{dir.app}/#{filename}.coffee"
        "#{dir.test}/#{filename}.test.coffee"
      ], { read : false }
        .pipe debug()
        .pipe clean()
        .on 'end', ->
          done()