define (require) ->

  BaseModel = require 'shared/base/model'

  class StegConfig extends BaseModel

    defaults:
      action: 'encode'
      algorithm: 'lsb'
      text: '123'
      channel: 'r'
      seed: ''
      channels: ['r', 'g', 'b']
      actions: ['encode', 'decode']
      types: ['lsb', 'lsbfixed', 'lsbseed', 'koha-jao']

    validation:
      action:
        required: true
      algorithm:
        required: true
      channel:
        required: true
      text:
        fn: 'validateText'
      step:
        fn: 'validateStep'
      seed:
        fn: 'validateSeed'
      seedCount:
        fn: 'validateSeedCount'
      factor:
        fn: 'validateFactor'

    initialize: ->
      super
      @on('change:factor', (model, value) -> @set('factor', parseInt(value, 10)))
      @on('change:seedCount', (model, value) -> @set('seedCount', parseInt(value, 10)))
      @on('change:step', (model, value) -> @set('step', parseInt(value, 10)))

    validateText: (value, attr, computedState) ->
      if computedState.action is 'encode' and !value
        return 'Text is required'

    validateStep: (value, attr, computedState) ->
      if computedState.algorithm is 'lsbfixed' and !value
        return 'Step is required'

    validateSeed: (value, attr, computedState) ->
      if computedState.algorithm in ['lsbseed', 'koha-jao'] and !value
        return 'Seed is required'

    validateSeedCount: (value, attr, computedState) ->
      if computedState.algorithm is 'lsbseed' and !value
        return 'Seed count is required'

    validateFactor: (value, attr, computedState) ->
      if computedState.algorithm is 'koha-jao' and !value
        return 'Factor is required'
