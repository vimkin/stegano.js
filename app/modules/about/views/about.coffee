define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/about.hbs')

  class AboutView extends BaseView

    template: template
    className: 'about'