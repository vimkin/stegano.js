define (require) ->

  BaseModel = require('shared/base/model')

  class Statistic extends BaseModel

    urlRoot: '/api/statistic'