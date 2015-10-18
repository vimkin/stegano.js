define (require) ->
  'use strict'

  rivets = require('rivets')

  # Config
  rivets.configure({

    # Attribute prefix in templates
    prefix: 'rv',

    # Preload templates with initial data on bind
    preloadData: true,

    # Root sightglass interface for keypaths
    rootInterface: '.',

    # Template delimiters for text bindings
    templateDelimiters: ['{', '}'],

  })

  # Adapters
  rivets.adapters[':'] = {

    observe: (obj, keypath, callback) ->
      obj.on('change:' + keypath, callback)

    unobserve: (obj, keypath, callback) ->
      obj.off('change:' + keypath, callback)

    get: (obj, keypath) ->
      obj.get(keypath)

    set: (obj, keypath, value) ->
      obj.set(keypath, value)

  }

  # Formatters
  rivets.formatters.number = (value) ->
    +value

  rivets.formatters.string = (value) ->
    return "#{value}"

  rivets.formatters.percentage = (value) ->
    value + '%'

  rivets.formatters.negate = (value) ->
    !value

  rivets.formatters.not_eq = (value, arg) ->
    value isnt arg

  rivets.formatters.eq = (value, arg) ->
    value is arg

  rivets.formatters.is_in = (value, args...) ->
    value in args

  rivets.formatters.gt = (value, arg) ->
    value > arg

  rivets.formatters.lt = (value, arg) ->
    value < arg
