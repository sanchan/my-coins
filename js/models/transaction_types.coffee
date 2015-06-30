class MyCoins.Models.TransactionType extends Backbone.Model
  defaults: ->
    id:   MyCoins.accountsCollection.nextOrder()
    name: null

  initialize: (options)->
    return @



class MyCoins.Collections.TransactionTypes extends Backbone.Collection
  model: MyCoins.Models.TransactionType

  localStorage: new Backbone.LocalStorage("TransactionTypes")

  nextOrder: ->
    return 1 if not this.length
    return this.last().get('id') + 1

  comparator: (account) ->
      return account.get('id')