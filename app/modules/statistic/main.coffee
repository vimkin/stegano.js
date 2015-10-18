define (require) ->

# libs, etc.
  Backbone = require('backbone')

  # MV
  Statistic = require('./models/statistic')
  Statistics = require('./models/statistics')
  StatisticTable = require('./views/statistic-table')

  # Base
  BaseController = require('shared/base/controller')

  class StatisticController extends BaseController

    initialize: ->
      Backbone.Mediator.subscribe('statistic:add:record', @addStatRecord)

    showStatisticTable: (options) ->
      @collection = new Statistics()
      @view = new StatisticTable({
        container: options.container
        collection: @collection
      })
      @collection.fetch()
      @view.render()

    addStatRecord: (data, options) ->
      model = new Statistic({
        data
      })
      model.save()


