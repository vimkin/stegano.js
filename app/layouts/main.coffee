define (require) ->

  Backbone = require('backbone')
  BaseView = require('shared/base/view')
  HeaderView = require('shared/views/header')
  template = require('text!./templates/main.hbs')

  class MainLayout extends BaseView

    template: template
    container: 'body'
    views: {}
    
    events:
      "click a[href^='/']": 'onInternalLinkClick'

    render: ->
      super
      @views.header = new HeaderView(container: @$('.global-header'))
      @views.header.render()

    getContentContainer: ->
      @$('.global-content-container')

    onInternalLinkClick: (e) ->
      href = $(e.currentTarget).attr('href')
      passThrough = href.indexOf('sign_out') >= 0

      # Allow shift+click for new tabs, etc.
      if !passThrough && !e.altKey && !e.ctrlKey && !e.metaKey && !e.shiftKey
        e.preventDefault()

        # Remove leading slashes and hash bangs (backward compatablility)
        url = href.replace(/^\//,'').replace('\#\!\/','')

        # Instruct Backbone to trigger routing events
        Backbone.Mediator.publish('navigate', href, {trigger: true})
