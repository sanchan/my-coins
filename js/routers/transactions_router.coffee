class MyCoins.Routers.Transactions extends Backbone.Router
  initialize: (options) ->

  routes:
    "transactions" : "index"
    "transaction/:id/show" : "show"

  index: ->

  show: (id)->
    @showView = new MyCoins.Views.Transactions.ShowView
      id: id
