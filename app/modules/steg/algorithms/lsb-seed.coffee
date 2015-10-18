define (require) ->

  seedrandom = require('seedrandom')
  LSBAlgorithm = require('./lsb')

  class LSBSeedAlgorithm extends LSBAlgorithm

    constructor: (image, channel, seed, count) ->
      super
      @rng = seedrandom(seed)
      @steps = @_getRandomNumberArr(@rng, count)
      @curStep = 0

    _getRandomNumberArr: (rng, count) ->
      for i in [0...count]
        Math.floor((rng() * 10) + 1)

    _nextPixel: ->
      if @curStep < @steps.length
        super(@steps[@curStep])
      else
        @curStep = 0
        super(@steps[@curStep])
      @curStep++


