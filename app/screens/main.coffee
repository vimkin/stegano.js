define (require) ->
  "use strict"

  BaseController = require('shared/base/controller')
  MainLayout = require('layouts/main')
  StegModule = require('modules/steg')
  StatisticModule = require('modules/statistic')

  class MainScreen extends BaseController
    routes:
      '': 'show'

    modules: {}

    onBeforeRoute: ->
      @layout = new MainLayout()

    show: ->
      console.log 'MainScreen#show'
      @layout.render()
      @modules.steg = new StegModule()
      @modules.statistic = new StatisticModule()
      @modules.steg.showStegForm(
        container: @layout.getContentContainer()
      )

    remove: ->
      @layout.remove()
      @modules.steg.remove()
      @modules.statistic.remove()
