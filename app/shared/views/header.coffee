define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/header.hbs')

  class HeaderView extends BaseView

    tagName: 'nav'
    className: 'navbar navbar-inverse navbar-static-top'
    template: template