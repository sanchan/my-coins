fakeData = ->
  # Transaction Categories
  if not MyCoins.transactionCategoriesCollection.length
    transactionCategories = ["Bills", "Car", "Clothing", "Health", "Housing", "Others", "Restaurants", "Taxes", "Transport", "Travels"]
    for t in transactionCategories
      MyCoins.transactionCategoriesCollection.create
        name: t

  # Accounts and Transactions
  if not MyCoins.accountsCollection.length
    MyCoins.accountsCollection.create
      name: "Cuenta Personal"
      type: "cash"

    transactions = [
      {
        accountId: 1
        date: "2014-06-01T00:00:00.000-03:00"
        description: "Sueldo"
        type: "income"
        value: 4000
      },
      {
        accountId: 1
        date: "2014-06-02T00:00:00.000-03:00"
        description: "Activesap"
        type: "income"
        value: 500
      },
      {
        accountId: 1
        date: "2014-06-03T00:00:00.000-03:00"
        description: "Matias"
        type: "expense"
        value: 1100
      },
      {
        accountId: 1
        date: "2014-07-01T00:00:00.000-03:00"
        description: "Sueldo"
        type: "income"
        value: 4000
      },
      {
        accountId: 1
        date: "2014-07-02T00:00:00.000-03:00"
        description: "Gomitas"
        type: "expense"
        value: 8500
      },
      {
        accountId: 1
        date: "2014-08-01T00:00:00.000-03:00"
        description: "Sueldo"
        type: "income"
        value: 4000
      },
      {
        accountId: 1
        date: "2014-08-01T00:00:00.000-03:00"
        description: "Venta riñon"
        type: "income"
        value: 200
      }
    ]

    for t in transactions
      MyCoins.transactionsCollection.create t


$(document).ready ->
  window.MyCoins = {}

  MyCoins.setCurrentModalView = (view)->
    if MyCoins.currentModalView
      MyCoins.currentModalView.remove()
      MyCoins.currentModalView.off()

    $("#app-modal").append view.render().el
    MyCoins.currentModalView = view

  MyCoins.setCurrentContentView = (view) ->
    if MyCoins.currentContentView
      MyCoins.currentContentView.remove()
      MyCoins.currentContentView.off()

    $("#app-content").append view.render().el
    MyCoins.currentContentView = view

  MyCoins.accountsCollection = new MyCoins.Collections.Accounts
  MyCoins.transactionCategoriesCollection = new MyCoins.Collections.TransactionCategories
  MyCoins.transactionsCollection = new MyCoins.Collections.Transactions
  MyCoins.budgetsCollection = new MyCoins.Collections.Budgets

  MyCoins.accountsCollection.fetch(reset: true)
  MyCoins.transactionCategoriesCollection.fetch(reset: true)
  MyCoins.transactionsCollection.fetch(reset: true)
  MyCoins.budgetsCollection.fetch(reset: true)

  # Lets create some fake data... just for fun ;)
  fakeData()

  sidebarView = new MyCoins.Views.Sidebar.ShowView

  $("#app-sidebar").append sidebarView.render().el

  $sidebarAccountWrapper = $("#sidebar-accounts-nav-wrapper")
  $sidebarAccountWrapper.width($sidebarAccountWrapper.width()).height($sidebarAccountWrapper.height()).perfectScrollbar()

  MyCoins.accountsRounter = new MyCoins.Routers.Accounts


  # Go!
  Backbone.history.start({pushState: true, root: "/#/"})

  $(document).on 'click', 'a:not([data-bypass])', (evt)->
    href = $(this).attr('href')
    protocol = this.protocol + '//'

    if (href.slice(protocol.length) != protocol)
      evt.preventDefault()
      Backbone.history.navigate(href, true)


  if MyCoins.accountsCollection.length > 0
    Backbone.history.navigate("account/1/show", true)
    #MyCoins.accountsRounter.show MyCoins.accountsCollection.first().get("id")
  else
    newAccountView = new MyCoins.Views.Accounts.NewView
      collection: MyCoins.accountsCollection
    MyCoins.setCurrentContentView newAccountView