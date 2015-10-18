define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/decoded.hbs')

  class DecodedModal extends BaseView

    el: '#modal-container'
    template: template

    initialize: (options) ->
      super
      @text = options.text

    render: ->
      super
      @$('#encoded-modal').modal('show')

    getTemplateData: ->
      super({text: @text})
