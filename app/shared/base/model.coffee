define (require) ->

  _ = require('underscore')
  Validation = require('validation')
  Backbone = require('backbone')

  class BaseModel extends Backbone.Model

    _.extend(@::, Validation.mixin)
