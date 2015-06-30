class MyCoins.Models.Budget extends Backbone.Model
  defaults: ->
    id:   MyCoins.accountsCollection.nextOrder()
    name: null # string
    amount: 0  # integer
    categoriesId: [] # TransactionCategories Id
    date: null # date


  initialize: (options)->
    return @



class MyCoins.Collections.Budgets extends Backbone.Collection
  model: MyCoins.Models.Budget

  localStorage: new Backbone.LocalStorage("Budgets")

  nextOrder: ->
    return 1 if not this.length
    return this.last().get('id') + 1

  comparator: (account) ->
      return account.get('id')