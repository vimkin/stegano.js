define (require) ->
  'use strict'

  Backbone = require('backbone')
  MainScreen = require('screens/main')
  AboutScreen = require('screens/about')
  HowtoScreen = require('screens/howto')

  class Router extends Backbone.Router
    controllers: {}

    initialize: ->
      Backbone.Mediator.subscribe('navigate', @internalNavigate)
      @controllers.main = new MainScreen({router: @})
      @controllers.about = new AboutScreen({router: @})
      @controllers.howto = new HowtoScreen({router: @})

    internalNavigate: (url, options) =>
      @navigate(url, options)

  new Router()

