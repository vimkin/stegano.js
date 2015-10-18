define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/lsb-form.hbs')

  class LSBForm extends BaseView

    template: template
    useDeclarative: true
