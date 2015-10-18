define (require) ->

  _ = require('underscore')
  utils = require('shared/lib/utils')
  BaseView = require('shared/base/view')
  template = require('text!./templates/image-input.hbs')

  class ImageInputView extends BaseView

    template: template
    tagName: 'div'
    className: 'image-input'

    events:
      'click': '_onClick'
      'change input': '_onChange'

    initialize: (options) ->
      super
      @size = {
        width: options.width or 200
        height: options.height or 200
      }

    getTemplateData: ->
      _.extend({}, @model.toJSON, @size)

    _onClick: ->
      console.log 'ImageInput#onCLick'

    _onChange: (e) ->
      $target = $(e.currentTarget)
      utils.readFileURL($target[0]).then(@_onImageLoaded)

    _setFocus: ->
      @$el.addClass("#{@className}--focus")

    _onImageLoaded: (url) =>
      utils.createImageFromUrl(url).then(@_onImageCreate)

    _onImageCreate: (image) =>
      @model.set('image', image)
      @_previewImage(image)

    _previewImage: (image) =>
      $img = @$(".#{@className}__img")
      $img.attr('src', @_adjust(image))

    _adjust: (image) ->
      canvas = document.createElement('canvas')
      canvas.width = @size.width
      canvas.height = @size.height
      context = canvas.getContext('2d')

      scaleWidth = @size.width / image.width
      scaleHeight = @size.height / image.height

      context.translate(0, 0)
      context.scale(scaleWidth, scaleHeight)
      context.drawImage(image, 0, 0)
      canvas.toDataURL()







