define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/lsb-seed-form.hbs')

  class LSBSeedForm extends BaseView

    template: template
    useDeclarative: true

