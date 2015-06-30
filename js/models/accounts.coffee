class MyCoins.Models.Account extends Backbone.Model
  defaults: ->
    id:   MyCoins.accountsCollection.nextOrder()
    name: null   # string
    type: "cash" # string ["checking", "cash", "credit", "savings"]
    currency: "NZD"

  initialize: (options)->
    return @

  balance: ->
    balance = 0
    MyCoins.transactionsCollection.where(accountId: @get("id")).each (transaction)->
      if transaction.get("type") == "income"
        balance += transaction.get("value")
      else
        balance -= transaction.get("value")

    balance


class MyCoins.Collections.Accounts extends Backbone.Collection
  model: MyCoins.Models.Account

  localStorage: new Backbone.LocalStorage("Accounts")

  nextOrder: ->
    return 1 if not this.length
    return this.last().get('id') + 1

  comparator: (account) ->
      return account.get('id')