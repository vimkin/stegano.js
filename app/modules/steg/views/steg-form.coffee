define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/steg-form.hbs')

  # Subviews
  LSBForm = require('./lsb-form')
  LSBFixedForm = require('./lsb-fixed-form')
  LSBSeedForm = require('./lsb-seed-form')
  KohaJaoForm = require('./koha-jao-form')
  ImageInput = require('shared/views/image-input')

  class StegForm extends BaseView

    template: template
    className: 'steg-form'
    useDeclarative: true

    events:
      'submit form': '_onFormSubmit'

    subviewCreators: ->
      'ImageInput': =>
        new ImageInput
          model: @model
          width: 200
          height: 200

      'LSBForm': =>
        new LSBForm
          model: @model

      'LSBFixedForm': =>
        new LSBFixedForm
          model: @model

      'LSBSeedForm': =>
        new LSBSeedForm
          model: @model

      'KohaJaoForm': =>
        new KohaJaoForm
          model: @model

    initialize: ->
      super
      @listenTo(@model, 'change', @_validateProceed)

    render: ->
      super
      @_validateProceed()

    _onFormSubmit: (e)->
      e.preventDefault()
      @model.trigger('submit', @model)

    _validateProceed: ->
      $proceedBtn = @$('.js-proceed')
      if @model.isValid(true)
        $proceedBtn.attr('disabled', false)
      else
        $proceedBtn.attr('disabled', true)

