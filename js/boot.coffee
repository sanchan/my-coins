MyCoins = {
  Views: {}
  Collections: {}
  Models: {}
  Routers: {}
}

class MyCoins.Config extends Backbone.DeepModel
  localStorage: new Backbone.LocalStorage('MyCoins.config')

  defaults:
    accounts:
      filter: "all"
      sort: "desc"

  initialize: ->

MyCoins.config = new MyCoins.Config
MyCoins.config.fetch()

onResizeWindow = (fn) ->
  addEvent = (elem, type, eventHandle) ->
    return if elem == null || typeof(elem) == 'undefined'
    if elem.addEventListener
        elem.addEventListener type, eventHandle, false
    else if elem.attachEvent
        elem.attachEvent "on" + type, eventHandle
    else
        elem["on"+type]=eventHandle


  addEvent window, "resize", fn
