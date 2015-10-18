define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/howto.hbs')

  class HowtoView extends BaseView

    template: template
    className: 'howto'