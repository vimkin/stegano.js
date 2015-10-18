define (require) ->
  "use strict"

  BaseController = require('shared/base/controller')
  MainLayout = require('layouts/main')
  AboutModule = require('modules/about')

  class AboutScreen extends BaseController
    routes:
      'about': 'show'

    modules: {}

    onBeforeRoute: ->
      @layout = new MainLayout()

    show: ->
      console.log 'AboutScreen#show'
      @layout.render()
      @modules.about = new AboutModule()
      @modules.about.showAboutMessage(
        container: @layout.getContentContainer()
      )

    remove: ->
      @layout.remove()
      @modules.about.remove()
