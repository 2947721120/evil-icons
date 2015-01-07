gulp         = require 'gulp'
sass         = require 'gulp-ruby-sass'
autoprefixer = require 'gulp-autoprefixer'
cssmin       = require 'gulp-cssmin'
jade         = require 'gulp-jade'
minifyHTML   = require 'gulp-minify-html'
imagemin     = require 'gulp-imagemin'
pngquant     = require 'imagemin-pngquant'
watch        = require 'gulp-watch'
connect      = require 'gulp-connect'
coffee       = require 'gulp-coffee'
uglify       = require 'gulp-uglify'
gutil        = require 'gulp-util'
concat       = require 'gulp-concat'
del          = require 'del'
fs           = require 'fs'
inline       = require 'gulp-inline-base64'
data         = require './data.json'
evilData     = require './node_modules/evil-icons/package.json'
evilIcons    = require 'gulp-evil-icons'

helpers =
  capitalize: (str) ->
    str
      .replace('ei-', '')
      .replace('sc-', '')
      .replace('-', '&nbsp;')
      .replace /(?:^|\s)\S/g, (s) -> s.toUpperCase()


iconsPath = './node_modules/evil-icons/assets/icons'
iconNames = (icon.replace('.svg', '') for icon in fs.readdirSync iconsPath)
jadeVars  =
  iconNames:  iconNames
  data:       data
  helpers:    helpers
  version:    evilData.version


gulp.task 'css', ->
  gulp.src 'src/app.scss'
    .pipe sass(quiet: true).on('error', gutil.log)
    .pipe inline(baseDir: './', debug: true)
    .pipe autoprefixer()
    .pipe cssmin(keepSpecialComments: 0)
    .pipe gulp.dest('assets')
    .pipe connect.reload()


gulp.task 'html', ->
  gulp.src 'src/index.jade'
    .pipe jade(locals: jadeVars)
    .pipe evilIcons()
    .pipe minifyHTML()
    .pipe gulp.dest('./')
    .pipe connect.reload()


gulp.task 'images', ->
  gulp.src 'src/images/*'
    .pipe imagemin
      progressive: true
      svgoPlugins: [{ removeViewBox: false }]
      use: [pngquant()]
    .pipe gulp.dest('assets/images')


gulp.task 'coffee', ->
  gulp.src 'src/scripts/*.coffee'
    .pipe coffee({bare: true}).on('error', gutil.log)
    .pipe concat('app.js')
    .pipe uglify()
    .pipe gulp.dest('assets')
    .pipe connect.reload()


gulp.task 'server', ['watch'], ->
  connect.server(root: './', livereload: false)


gulp.task 'watch', ->
  gulp.watch('src/**', ['build'])


gulp.task 'clean', (cb) ->
  del 'index.html', cb
  del 'assets', cb


gulp.task 'build', ['images', 'css', 'coffee', 'html']
gulp.task 'default', ['build', 'server']

