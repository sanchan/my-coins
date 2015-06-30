MyCoins.Views.Accounts ||= {}

class MyCoins.Views.Accounts.ShowView extends Backbone.View
  template: """
    <article id="show-account">
      <header id="show-account-header">
        <div id="show-account-header-btn-group-1" class="btn-group">
          <button id="show-account-header-sort-btn" type="button" class="btn btn-default">Sort <span class="fa fa-long-arrow-down"></span></button>
          <button id="show-account-header-filters-btn" type="button" class="btn btn-default" data-placement="bottom">Filters</button>
          <div id="show-account-header-filters-btn-popover-content" style="display: none;">
            <div class="input-group">
              <span class="input-group-addon">Type</span>
              <div class="btn-group">
                <button id="show-account-header-filters-btn-all" data-filter="all" type="button" class="btn btn-default">All</button>
                <button id="show-account-header-filters-btn-income" data-filter="income" type="button" class="btn btn-default">Income</button>
                <button id="show-account-header-filters-btn-expense" data-filter="expense" type="button" class="btn btn-default">Expense</button>
              </div>
            </div>
          </div>
        </div>

        <div id="show-account-header-btn-group-3" class="btn-group">
          <span class="fa fa-search"></span>
          <span class="caret"></span>
          <input id="show-account-header-search-input" type="text">
        </div>

        <div id="show-account-header-btn-group-2" class="btn-group">
          <button id="show-account-header-list-btn" type="button" class="btn btn-default"><span class="fa fa-list"></span><span class="sr-only">List View</span></button>
          <button id="show-account-header-table-btn" type="button" class="btn btn-default"><span class="fa fa-table"></span><span class="sr-only">Table View</span></button>
        </div>

      </header>

      <div id="show-account-content">
        <ul id="show-account-transactions-list" class="nav"></ul>
      </div>

      <footer id="show-account-footer">
        <div id="show-account-footer-balance">
          <span class="balance-text">Balance</span>
          <span class="balance-value">0,00 NZD</span>
        </div>

        <div id="show-account-footer-new-group" class="btn-group dropup">
          <button type="button" class="btn btn-default"><span class="fa fa-plus"></span><span class="sr-only">Add new transaction</span></button>
          <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Add new transaction</span>
          </button>
          <ul class="dropdown-menu dropdown-menu-right" role="menu">
            <li id="show-account-footer-new-expense"><span>New Expense</span></li>
            <li id="show-account-footer-new-income"><span>New Income</span></li>
          </ul>
        </div>

      </footer>
    </article>
  """

  templateLabel: """
    <li class="label-list-item">
      <span class="label-title-wrapper">
	      <i class="fa fa-calendar"></i>
        <span class="title"></span>
      </span>
      <span class="balance">Total Balance:<span class="value"></span></span>
      <span class="monthly-balance">Monthly Balance:<span class="value"></span> |</span>
    </li>
  """

  events:
    "keyup #show-account-header-search-input": "keyupSearch"
    "click #show-account-footer-new-group .btn": "toggleNewPopup"
    "click #show-account-header-sort-btn": "toggleSort"
    "click #show-account-header-btn-group-1 [data-filter]": "setFilter"
    "click #show-account-footer-new-expense": "newExpense"
    "click #show-account-footer-new-income": "newIncome"

  transactions: []
  searchWord: ""

  keyupSearch: (ev)->
    @searchWord = $(ev.target).val().trim()
    @addTransactions()


  newExpense: (ev)->
    @newExpenseModalView = new MyCoins.Views.Transactions.NewTransactionModalView
      accountId: @model.get("id")

    MyCoins. setCurrentModalView @newExpenseModalView

    @newExpenseModalView.show()

  newIncome: (ev)->
    @newIncomeModalView = new MyCoins.Views.Transactions.NewTransactionModalView
      accountId: @model.get("id")
      type: "income"

    MyCoins. setCurrentModalView @newIncomeModalView

    @newIncomeModalView.show()

  toggleNewPopup: (ev)->
    ev.stopPropagation()
    @$("#show-account-footer-new-group").toggleClass "open"

  toggleSort: (ev)->
    ev.stopPropagation()
    if @$("#show-account-header-sort-btn .fa").hasClass "fa-long-arrow-down"
      @$("#show-account-header-sort-btn .fa").removeClass "fa-long-arrow-down"
      @$("#show-account-header-sort-btn .fa").addClass "fa-long-arrow-up"
      @$("#show-account-header-sort-btn").attr "data-order", "asc"
      MyCoins.config.set "accounts.sort", "asc"
    else
      @$("#show-account-header-sort-btn .fa").removeClass "fa-long-arrow-up"
      @$("#show-account-header-sort-btn .fa").addClass "fa-long-arrow-down"
      @$("#show-account-header-sort-btn").attr "data-order", "desc"
      MyCoins.config.set "accounts.sort", "desc"
    MyCoins.config.save()
    MyCoins.config.fetch()

    @addTransactions()

  addTransaction: (transaction)=>
    @transactions.push new MyCoins.Views.Transactions.TransactionView
      model: transaction

    @$("#show-account-transactions-list").prepend @transactions.last().render().el

  addTransactions: ->
    @transactions.each (t) ->
      t.off()
      t.remove()

    @$("#show-account-transactions-list li").off()
    @$("#show-account-transactions-list li").remove()

    transactionsCollection = MyCoins.transactionsCollection.sortBy("date")

    # We have to get the total balance for each month before doing .reverse() on transactionsCollection because if we don't
    # then the calculed value will be wrong.
    totalBalances = []

    filter = MyCoins.config.get("accounts").filter

    filteredGroup = {}

    groupedTrasactions = _.groupBy transactionsCollection, (transaction) ->
      # TODO groupBy Year first, then by Month
      Date.create(transaction.get("date")).format("{Month}")

    _.each groupedTrasactions, (group, key)=>
      filteredGroup[key] = _.filter group, (transaction) =>
        if @searchWord.length < 3
          return (filter == "all" || transaction.get("type") == filter) and (transaction.get("accountId") == @model.get("id"))
        else
          return (filter == "all" || transaction.get("type") == filter) and (transaction.get("accountId") == @model.get("id")) and (transaction.get("description").toLowerCase().search(@searchWord.toLowerCase()) != -1)


    idx = 0
    _.each filteredGroup, (group, key)=>
      if idx == 0
        totalBalances[idx] = 0
      else
        totalBalances[idx] = totalBalances[idx-1]
      group.each (transaction)=>
        if filter == "income"
          totalBalances[idx] += transaction.get("value")
        else if filter == "expense"
          totalBalances[idx] -= transaction.get("value")
        else if filter == "all"
          if transaction.get("type") == "income"
            totalBalances[idx] += transaction.get("value")
          else # expense
            totalBalances[idx] -= transaction.get("value")
      idx++

    filteredGroup = {}

    if @$("#show-account-header-sort-btn").attr("data-order") == "asc"
      totalBalances = totalBalances.reverse()
      transactionsCollection = transactionsCollection.reverse()

    groupedTrasactions = _.groupBy transactionsCollection, (transaction) ->
      # TODO groupBy Year first, then by Month
      Date.create(transaction.get("date")).format("{Month}")


    _.each groupedTrasactions, (group, key)=>
      filteredGroup[key] = _.filter group, (transaction) =>
        if @searchWord.length < 3
          return (filter == "all" || transaction.get("type") == filter) and (transaction.get("accountId") == @model.get("id"))
        else
          return (filter == "all" || transaction.get("type") == filter) and (transaction.get("accountId") == @model.get("id")) and (transaction.get("description").toLowerCase().search(@searchWord.toLowerCase()) != -1)

    balance = 0
    totalBalancesIndex = 0
    _.each filteredGroup, (group, key)=>
      monthlyBalance = 0
      group.each (transaction, idx)=>
        if filter == "income"
          monthlyBalance += transaction.get("value")
        else if filter == "expense"
          monthlyBalance -= transaction.get("value")
        else if filter == "all"
          if transaction.get("type") == "income"
            monthlyBalance += transaction.get("value")
          else # expense
            monthlyBalance -= transaction.get("value")
        @addTransaction transaction
        @addMonthLabel(key, totalBalances[totalBalancesIndex]) if (transaction.get("accountId") == @model.get("id")) and (idx == group.length - 1)

      # Monthly balance
      @$(".label-list-item .monthly-balance .value").first().text monthlyBalance.format() + " " + MyCoins.transactionsCollection.currency()
      @$(".label-list-item .monthly-balance").first().addClass "negative-balance" if monthlyBalance < 0

      # Total balance
      @$(".label-list-item .balance .value").first().text totalBalances[totalBalancesIndex].format() + " " + MyCoins.transactionsCollection.currency()
      @$(".label-list-item .balance").first().addClass "negative-balance" if balance < 0

      footerBalance = 0
      MyCoins.transactionsCollection.each (transaction, idx)=>
        if transaction.get("accountId") == @model.get("id")
          if transaction.get("type") == "income"
            footerBalance += transaction.get("value")
          else if transaction.get("type") == "expense"
            footerBalance -= transaction.get("value")
      @$("#show-account-footer-balance .balance-value").text footerBalance.format() + " " + MyCoins.transactionsCollection.currency()

      totalBalancesIndex++

  initialize: (options)->

    MyCoins.transactionsCollection.on "add remove change change", =>
      @addTransactions()

  addMonthLabel: (month)->
    @$("#show-account-transactions-list").prepend @templateLabel
    @$(".label-list-item .title").first().text month

  setFilter: (ev)->
    filter = $(ev.target).closest(".btn").attr "data-filter"
    accountsConfig = MyCoins.config.get("accounts")
    accountsConfig.filter = filter
    MyCoins.config.set "accounts", accountsConfig
    MyCoins.config.save()
    @$("#show-account-header-btn-group-1 .btn").removeClass "active"
    @$("#show-account-header-btn-group-1 .btn[data-filter=" + filter + "]").addClass "active"
    MyCoins.transactionsCollection.trigger "change"

  render: ->
    @$el.append @template
    @$el.find("#new-modal-account").hide()

    # Set filter
    @$("#show-account-header-btn-group-1 [data-filter=" + MyCoins.config.get("accounts").filter + "]").click()

    # Ser sorting order
    @$("#show-account-header-sort-btn").attr "data-order", MyCoins.config.get("accounts").sort

    @$("#show-account-header-list-btn").addClass "active"
    @$("#show-account-header-table-btn").click ->
      alert "Not implemented yet :)"

    # Config filter popover
    @$("#show-account-header-filters-btn").popover
      html : true
      content: =>
        @$("#show-account-header-filters-btn-popover-content").html()

    @addTransactions()

    @