class MyCoins.Models.TransactionCategory extends Backbone.Model

  defaults: ->
    id: MyCoins.transactionCategoriesCollection.nextOrder()
    name: "" # string
    parentCategoryId: null # integer

  initialize: (options)->
    return @


class MyCoins.Collections.TransactionCategories extends Backbone.Collection
  model: MyCoins.Models.TransactionCategory

  localStorage: new Backbone.LocalStorage("TransactionCategories")

  nextOrder: ->
    return 1 if not this.length
    return this.last().get('id') + 1
