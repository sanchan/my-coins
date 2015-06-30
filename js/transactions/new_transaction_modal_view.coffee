MyCoins.Views.Transactions ||= {}

class MyCoins.Views.Transactions.NewTransactionModalView extends Backbone.View
  template: """
    <article id="new-transaction-modal" class="my-coins-modal">
      <header>Create a new Transaction</header>
      <form class="box">

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Account</span>
            <div id="new-transaction-account-group" class="input-group-btn">
              <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text"></span> <span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-menu-right" role="menu"></ul>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Type</span>
            <div id="new-transaction-type-group" class="input-group-btn">
              <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text">Income</span> <span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-menu-right" role="menu">
                <li><span>Income</span></li>
                <li><span>Expense</span></li>
              </ul>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Category</span>
            <div id="new-transaction-category-group" class="input-group-btn">
              <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text">None</span> <span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-menu-right" role="menu">
                <li data-category-id><span>None</span></li>
              </ul>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Description</span>
            <div id="new-transaction-description-input" class="input-group-btn">
              <input id="new-transaction-description" type="text">
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Paid</span>
            <div id="new-transaction-paid-radio" class="input-group-btn">
              <input id="new-transaction-paid" type="checkbox">
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Amount</span>
            <div class="input-group input-dropdow">
              <input id="new-transaction-amount" type="text" placeholder=0>
              <div id="new-transaction-currency" class="input-group-btn">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text">NZD</span> <span class="caret"></span></button>
                <ul class="dropdown-menu dropdown-menu-right" role="menu">
                  <li class="account" data-account-id=""><span>ARS</span></li>
                  <li class="account" data-account-id=""><span>NZD</span></li>
                  <li class="account" data-account-id=""><span>USD</span></li>
                </ul>
              </div>
            </div>
          </div>
        </div>


        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Date</span>
            <div class="input-group date">
              <input type="text" placeholder="YYYY/MM/DD"><span class="input-group-addon"><i class="fa fa-calendar"></i></span>
            </div>
          </div>
        </div>


      </form>
      <footer>
        <button id="new-modal-account-cancel-btn" class="btn btn-default">Cancel</button>
        <button id="new-modal-account-done-btn" class="btn btn-primary">Done</button>
      </footer>
    </article>
  """

  templateAccount: """<li class="account" data-account-id=""><span>New Account</span></li>"""
  templateTransactionCategory: """<li class="transaction-category" data-category-id=""><span>New Account</span></li>"""

  mode: "new"
  type: "expense"

  events:
    "click #new-transaction-account-group .account": "clickAccount"
    "click #new-transaction-type-group li": "clickType"
    "click #new-transaction-category-group li": "clickCategory"
    "keydown #new-transaction-amount": "keydownAmount"
    "blur #new-transaction-description": "blurDescription"
    "keyup #new-transaction-amount": "keyupAmount"
    "click #new-modal-account-cancel-btn": "hide"
    "click #new-modal-account-done-btn": "submit"

  initialize: (options)->
    @collection = MyCoins.transactionsCollection

    @type = options.type if options?.type

    if not options?.model
      @model = new @collection.model
      @model.set "accountId", options.accountId
    else
      @mode = "edit"

  clickAccount: (ev)->
    accountId = parseInt($(ev.target).closest(".account").attr "data-account-id")
    @$("#new-transaction-account-group .btn:first-of-type .text")
      .text MyCoins.accountsCollection.findWhere(id: accountId).get "name"
      .attr "data-account-id", accountId


  clickType: (ev)->
    @$("#new-transaction-type-group .btn:first-of-type .text").text $(ev.target).closest("li span").text()

  clickCategory: (ev)->
    @$("#new-transaction-category-group .btn:first-of-type .text").text $(ev.target).closest("li span").text()
    @$("#new-transaction-category-group .btn").attr "data-category-id", $(ev.target).closest("li").attr "data-category-id"

  show: ->
    $("#app-modal").fadeIn()

  hide: ->
    $("#app-modal").fadeOut()

  keydownAmount: (ev)->
    a=[8,9,13,16,17,18,20,27,35,36,37,38,39,40,45,46,91,92]
    k = ev.which

    for i in [48..58]
      a.push(i)
    for i in [96..106]
      a.push(i)

    if not (a.indexOf(k) >= 0)
      ev.preventDefault()

  keyupAmount: (ev)->
    $(ev.target).val Number($(ev.target).val().replace(/[\,\.\s]/gi, '')).format()

  blurDescription: (ev)->
    $(ev.target).val $(ev.target).val().trim()

  submit: (ev)->
    @$(".row").removeClass "error"
    if @$("#new-transaction-description").val().trim() == ""
      @$("#new-transaction-description").closest(".row").addClass "error"
    else
      value =  0
      value = @$("#new-transaction-amount").val() if @$("#new-transaction-amount").val() != ""
      @model.set "accountId", parseInt(@$("#new-transaction-account-group .btn:first-of-type .text").attr "data-account-id")
      @model.set "type", @$("#new-transaction-type-group .btn:first-of-type .text").text().toLowerCase()
      @model.set "categoryId", @$("#new-transaction-category-group .btn").attr "data-category-id" if @$("#new-transaction-category-group .btn").attr "data-category-id"
      @model.set "description", @$("#new-transaction-description").val()
      @model.set "paid", @$("#new-transaction-paid").prop "checked"
      @model.set "value", Number(String(value).replace(/[\,\.\s]/gi, ''))
      @model.set "date", @$('.input-group.date').datepicker("getDate").format(Date.ISO8601_DATETIME)

      if @mode == "new"
        @collection.create @model
        @hide()
      else # edit
        @model.save @model.attributes, silent: true
        @collection.trigger "change"
        @hide()

  render: ->
    @$el.append @template
    @$("#new-transaction-account-group .btn:first-of-type .text")
      .text MyCoins.accountsCollection.findWhere(id: @model.get "accountId").get "name"
      .attr "data-account-id", @model.get "accountId"


    MyCoins.accountsCollection.each (account)=>
      $account = $(@templateAccount)
      $account.attr "data-account-id", account.get "id"
      $account.find("span").text account.get "name"
      @$("#new-transaction-account-group .dropdown-menu").append $account

    MyCoins.transactionCategoriesCollection.each (category)=>
      $category = $(@templateTransactionCategory)
      $category.attr "data-category-id", category.get "id"
      $category.find("span").text category.get "name"
      @$("#new-transaction-category-group .dropdown-menu").append $category

    @$('.input-group.date').datepicker
      format: "yyyy/mm/dd"
      autoclose: true
      todayHighlight: true

    @$('.input-group.date').datepicker "update", Date.create().format "yyyy/mm/dd"

    if @mode == "new"
      @model.set "date", @$('.input-group.date').datepicker("getDate").format(Date.ISO8601_DATETIME)
      @$("#new-transaction-type-group .btn:first-of-type .text").text @type.capitalize()
      @$("#new-transaction-paid").prop "checked", true
    else # edit
      @$('header').text "Editing a Transaction"
      @$("#new-transaction-account-group .btn:first-of-type .text").text MyCoins.accountsCollection.findWhere(id: @model.get "accountId").get "name"
      @$("#new-transaction-type-group .btn:first-of-type .text").text @model.get("type").capitalize()
      @$("#new-transaction-category-group .btn:first-of-type .text")
        .text(MyCoins.transactionCategoriesCollection.get(@model.get("categoryId"))?.get("name") || "None")
        .attr("data-category-id", @model.get("categoryId"))
      @$("#new-transaction-description").val @model.get "description"
      @$("#new-transaction-paid").prop "checked", @model.get("paid")
      @$("#new-transaction-amount").val @model.get("value").format()
      @$('.input-group.date').datepicker "update", Date.create(@model.get("date")).format "{yyyy}/{MM}/{dd}"


    $("body").on "click", (ev)=>
      @$(".btn-group").removeClass "open"

    return @