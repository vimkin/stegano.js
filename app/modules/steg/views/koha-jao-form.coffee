define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/koha-jao-form.hbs')

  class LSBForm extends BaseView

    template: template
    useDeclarative: true
