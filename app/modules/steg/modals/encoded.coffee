define (require) ->

  BaseView = require('shared/base/view')
  template = require('text!./templates/encoded.hbs')

  class EncodedModal extends BaseView

    el: '#modal-container'
    template: template

    initialize: (options) ->
      super
      @imageHref = options.imageHref

    render: ->
      super
      @$('#encoded-modal').modal('show')

    getTemplateData: ->
      super({imageHref: @imageHref})
