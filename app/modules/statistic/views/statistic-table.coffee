define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/statistic-table.hbs')

  class StegForm extends BaseView

    template: template
    className: 'statistic-table'
