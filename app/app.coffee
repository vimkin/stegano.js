define (require) ->
  'use strict'

  Router = require('router') # Initialize Router
  Backbone = require('backbone')

  # Vendor libs
  require('bootstrap')
  require('shared/rivets')

  class App
    root: '/'

    constructor: ->
      Backbone.history.start(
        pushState: true
        root: @root
      )
