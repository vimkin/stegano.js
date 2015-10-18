define (require) ->

  require('subviews')
  _ = require('underscore')
  rivets = require('rivets')
  Backbone = require('backbone')
  Handlebars = require('handlebars')

  class BaseView extends Backbone.View

    useDeclarative: false

    initialize: (options) ->
      Backbone.Subviews.add(@)

      if @template
        @template = Handlebars.compile(@template)
      if options?.container
        @container = options.container

    render: ->
      @$el.html(@template(@getTemplateData()))
      @$el.appendTo(@container)
      @_bindRivets() if @useDeclarative and @model

    getTemplateData: (args...) ->
      obj = _.extend({}, @model?.toJSON())
      _.extend(obj, args[i]) for arg, i in args
      obj

    _bindRivets: ->
      if @rivets
        @rivets.build()
      else
        @rivets = rivets.bind(@$el, model: @model)