#
# Run layout code & determine which app code to run. As assets get too large we
# can break this up into self-initializing app-level asset packages like Force.
#

sd = require('sharify').data
window.jQuery = window.$ = $ = require 'jquery'

$ ->
  require('../components/layout/client.coffee').init()
  if sd.URL.match /// /articles/new|.*/edit ///
    require('../apps/edit/client.coffee').init()