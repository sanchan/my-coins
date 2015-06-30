class MyCoins.Routers.Accounts extends Backbone.Router
  initialize: (options) ->

  routes:
    "accounts"      : "index"
    "account/:id/show" : "show"

  index: ->

  show: (id)->
    @showView = new MyCoins.Views.Accounts.ShowView
      model: MyCoins.accountsCollection.get(id)

    MyCoins.setCurrentContentView @showView

    $content = $("#show-account-content")

    # FIXME These are magic numbers... I don't know why I can't get the correct values, it looks like the #app-content-wrapper:before is doing something weird.
    $content.width($("#app-content").innerWidth()).height($("#app-content").innerHeight() - 49*2).perfectScrollbar()

    onResizeWindow ->
      $content.width($("#app-content").innerWidth()).height($("#app-content").innerHeight() - 49*2).perfectScrollbar()
