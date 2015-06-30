class MyCoins.Models.Transaction extends Backbone.Model

  defaults: ->
    id: MyCoins.transactionsCollection.nextOrder()
    type: "expense"  # string ["income", "expense", "transfer", "adjust"]
    description: "Transaction-" + MyCoins.transactionsCollection.nextOrder()
    categoryId: null  # ID
    value: 0        # integer
    accountId: null # integer
    paid: true      # boolean
    currency: "NZD" # string

  initialize: (options)->
    return @

  togglePaid: ->
    @set "paid", not @get "paid"

class MyCoins.Collections.Transactions extends Backbone.Collection
  model: MyCoins.Models.Transaction

  localStorage: new Backbone.LocalStorage("Transactions")

  nextOrder: ->
    return 1 if not this.length
    return this.last().get('id') + 1

  comparator: (account) ->
      return account.get('id')

  balance: ->
    balance = 0
    @each (transaction) =>
      if transaction.get("type") == "income"
        balance += transaction.get("value")
      else
        balance -= transaction.get("value")

    balance

  currency: ->
    "NZD"