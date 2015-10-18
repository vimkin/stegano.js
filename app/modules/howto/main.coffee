define (require) ->

  # MV
  HowtoView = require('./views/howto')

  # Base
  BaseController = require('shared/base/controller')

  class HowtoController extends BaseController

    showHowtoMessage: (options) ->
      @view = new HowtoView(options)
      @view.render()