"use strict"

requirejs.config
  paths:
    "backbone": "../bower_components/backbone/backbone"
    "underscore": "../bower_components/lodash/lodash"
    "jquery": "../bower_components/jquery/dist/jquery"
    "controller": "../bower_components/backbone.controller/backbone.controller"
    "handlebars": "../bower_components/handlebars/handlebars"
    "text": "../bower_components/requirejs-text/text"
    "bootstrap": "../bower_components/bootstrap-sass-official/assets/javascripts/bootstrap"
    "mediator": "../bower_components/backbone-mediator/backbone-mediator"
    "seedrandom": "../bower_components/seedrandom/seedrandom"
    "select2": "../bower_components/select2/select2.min"
    "subviews": "../bower_components/backbone.subviews/backbone.subviews"
    "holderjs": "../bower_components/holderjs/holder.min"
    "Q": "../bower_components/q/q"
    "validation": "../bower_components/backbone-validation/dist/backbone-validation-amd-min"
    "rivets": "../bower_components/rivets/dist/rivets.min"
    "sightglass": "../bower_components/sightglass/index"

  shim:
    "backbone":
      deps: ["underscore", "jquery"]
      exports: "Backbone"

    "subviews":
      deps: ["backbone"]

    "select2":
      deps: ["jquery"]

    "underscore":
      exports: "_"

    "controller":
      deps: ["underscore", "backbone"]

    "bootstrap":
      deps: ["jquery"]

    "mediator":
      deps: ["backbone"]

    "app":
      deps: ["controller", "mediator"]

    "validation":
      deps: ["backbone", "underscore"]

    "rivets":
      deps: ["sightglass"]
      exports: "rivets"

  packages: [
    'modules/steg'
    'modules/about'
    'modules/howto'
    'modules/statistic'
  ]

require ['app'], (App) -> new App()