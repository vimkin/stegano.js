define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/lsb-fixed-form.hbs')

  class LSBFixedForm extends BaseView

    template: template
    useDeclarative: true

