define (require) ->

  LSBAlgorithm = require('./lsb')

  class LSBFixedAlgorithm extends LSBAlgorithm

    constructor: (image, channel, step) ->
      super
      @step = step

    _nextPixel: ->
      super(@step)