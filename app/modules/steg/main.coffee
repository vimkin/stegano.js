define (require) ->

  # libs, etc.
  Backbone = require('backbone')

  # MV
  StegConfig = require('./models/steg-config')
  StegForm = require('./views/steg-form')

  # Modals
  EncodedModal = require('./modals/encoded')
  DecodedModal = require('./modals/decoded')

  # Algorithms
  LSBAlgorithm = require('./algorithms/lsb')
  LSBFixedAlgorithm = require('./algorithms/lsb-fixed')
  LSBSeedAlgorithm = require('./algorithms/lsb-seed')
  KohaJao = require('./algorithms/koha-jao')

  # Base
  BaseController = require('shared/base/controller')

  class StegController extends BaseController

    showStegForm: (options) ->
      @model = new StegConfig()
      @listenTo(@model, 'submit', @_parseStegConfigModel)
      @view = new StegForm({
        container: options.container
        model: @model
      })
      @view.render()

    stegEncode: (algorithm, text, data) ->
      @_pickAlgorithm(algorithm, data)
      console.time('test')
      @algorithm.hideText(text)
      console.timeEnd(('test'))
      @modal = new EncodedModal({
        container: '#modal-container'
        imageHref: @algorithm.getImageUrl()
      })
      @modal.render()
      Backbone.Mediator.publish('statistic:add:record', data)

    stegDecode: (algorithm, data) ->
      @_pickAlgorithm(algorithm, data)
      @modal = new DecodedModal({
        container: '#modal-container'
        text: @algorithm.revealText()
      })
      @modal.render()

    _parseStegConfigModel: (model) ->
      action = model.get('action')
      algorithm = model.get('algorithm')
      text = model.get('text')
      data = model.pick('image', 'channel', 'step', 'seed', 'seedCount', 'factor')

      if action is 'encode'
        @stegEncode(algorithm, text, data)
      else if action is 'decode'
        @stegDecode(algorithm, data)
      else
        throw new Error('Wrong action')

    _pickAlgorithm: (algorithm, data) ->
      unless algorithm or data
        throw new Error('Wrong algorithm arguments')

      if algorithm is 'lsb'
        @algorithm = new LSBAlgorithm(
          data.image,
          data.channel
        )
      else if algorithm is 'lsbfixed'
        @algorithm = new LSBFixedAlgorithm(
          data.image,
          data.channel,
          data.step
        )
      else if algorithm is 'lsbseed'
        @algorithm = new LSBSeedAlgorithm(
          data.image,
          data.channel,
          data.seed,
          data.seedCount
        )
      else if algorithm is 'koha-jao'
        @algorithm = new KohaJao(
          data.image,
          data.channel,
          data.factor,
          data.seed
        )
      else
        throw new Error('Wrong algorithm')

      return @algorithm
