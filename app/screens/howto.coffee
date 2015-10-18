define (require) ->
  "use strict"

  BaseController = require('shared/base/controller')
  MainLayout = require('layouts/main')
  HowtoModule = require('modules/howto')

  class HowtoScreen extends BaseController
    routes:
      'howto': 'show'

    modules: {}

    onBeforeRoute: ->
      @layout = new MainLayout()

    show: ->
      console.log 'HowtoScreen#show'
      @layout.render()
      @modules.howto = new HowtoModule()
      @modules.howto.showHowtoMessage(
        container: @layout.getContentContainer()
      )

    remove: ->
      @layout.remove()
      @modules.howto.remove()
