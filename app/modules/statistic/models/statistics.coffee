define (require) ->

  BaseCollection = require('shared/base/collection')

  class Statistics extends BaseCollection

    url: '/api/statistic'

