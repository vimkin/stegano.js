define (require) ->

  # MV
  AboutView = require('./views/about')

  # Base
  BaseController = require('shared/base/controller')

  class AboutController extends BaseController

    showAboutMessage: (options) ->
      @view = new AboutView(options)
      @view.render()