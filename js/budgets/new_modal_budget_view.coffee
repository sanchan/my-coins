MyCoins.Views.Budgets ||= {}

class MyCoins.Views.Budgets.NewBudgetModalView extends Backbone.View
  template: """
    <article id="new-budget-modal" class="my-coins-modal">
      <header>Create a new Budget</header>
      <form class="box">

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Name</span>
            <div id="new-budget-name-input" class="input-group-btn">
              <input id="new-budget-name" type="text">
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Accounts to watch</span>
            <div id="new-budget-account-group" class="input-group-btn">
              <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text"></span> <span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-menu-right" role="menu">
              </ul>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Categories to watch</span>
            <div id="new-budget-category-group" class="input-group-btn">
              <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text"></span> <span class="caret"></span></button>
              <ul class="dropdown-menu dropdown-menu-right" role="menu">

              </ul>
            </div>
          </div>
        </div>


        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Amount</span>
            <div class="input-group input-dropdow">
              <input id="new-budget-amount" type="text" placeholder=0>
              <div id="new-budget-amount-dropdown" class="input-group-btn">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text">NZD</span> <span class="caret"></span></button>
                <ul class="dropdown-menu dropdown-menu-right" role="menu">
                  <li><span>ARS</span></li>
                  <li><span>NZD</span></li>
                  <li><span>USD</span></li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Start Date</span>
            <div class="input-group date">
              <input id="new-budget-start-date" type="text" placeholder="YYYY/MM/DD"><span class="input-group-addon"><i class="fa fa-calendar"></i></span>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Repeat</span>
            <div class="input-group input-dropdow">
              <input id="new-budget-repeat" type="checkbox">
            </div>
          </div>
        </div>

        <div class="row">
          <div class="input-group col-lg-12">
            <span class="input-group-addon">Frequency</span>
            <div class="input-group input-dropdow">
              <div id="new-budget-frequency" class="input-group-btn">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"><span class="text">Monthly</span> <span class="caret"></span></button>
                <ul class="dropdown-menu dropdown-menu-right" role="menu">
                  <li><span>Monthly</span></li>
                  <li><span>Yearly</span></li>
                </ul>
              </div>
            </div>
          </div>
        </div>


      </form>
      <footer>
        <button id="new-modal-budget-cancel-btn" class="btn btn-default">Cancel</button>
        <button id="new-modal-budget-done-btn" class="btn btn-primary">Done</button>
      </footer>
    </article>
  """

  templateAccount: """<li class="account" data-account-id=""><span></span></li>"""
  templateTransactionCategory: """
    <li class="display-table">
      <div class="input-group col-lg-12">
        <span class="input-group-addon"></span>
        <div class="input-group-btn">
          <input type="checkbox">
        </div>
      </div>
    </li>
  """
  mode: "new"
  type: "expense"
  transactionCategories: []

  events:
    "click #new-budget-account-group .account": "clickAccount"
    "click #new-budget-category-group li": "clickCategory"
    "click #new-modal-budget-cancel-btn": "hide"
    "click #new-modal-budget-done-btn": "submit"
    "keydown #new-budget-amount": "keydownAmount"
    "keyup #new-budget-amount": "keyupAmount"

  initialize: (options)->
    @type = options.type if options?.type

    if not options?.model
      @model = new MyCoins.budgetsCollection.model
    else
      @mode = "edit"

  clickAccount: (ev)->
    accountId = parseInt($(ev.target).closest(".account").attr "data-account-id")
    @$("#new-budget-account-group .btn:first-of-type .text")
      .text MyCoins.accountsCollection.findWhere(id: accountId).get "name"
      .attr "data-account-id", accountId

  clickCategory: (ev)->
    $input = $(ev.target).closest("li input")
    console.log $input, $(ev.target)
    if $(ev.target) != $input
      ev.stopPropagation()
      ev.preventDefault()
      console.log $input.prop("checked")
      $input.prop "checked", true
      @$("#new-budget-category-group .btn:first-of-type .text").text $(ev.target).closest("li span").text()
      @$("#new-budget-category-group .btn").attr "data-category-id", $(ev.target).closest("li").attr "data-category-id"

  show: ->
    $("#app-modal").fadeIn()

  hide: ->
    $("#app-modal").fadeOut()

  keydownAmount: (ev)->
    a = [8,9,13,16,17,18,20,27,35,36,37,38,39,40,45,46,91,92]
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

    value =  0
    value = @$("#new-transaction-amount").val() if @$("#new-transaction-amount").val() != ""
    @model.set "accountId", parseInt(@$("#new-transaction-account-group .btn:first-of-type .text").attr "data-account-id")
    @model.set "categoryId", @$("#new-budget-category-group .btn").attr "data-category-id" if @$("#new-budget-category-group .btn").attr "data-category-id"
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

    MyCoins.accountsCollection.each (account)=>
      $account = $(@templateAccount)
      $account.attr "data-account-id", account.get "id"
      $account.find("span").text account.get "name"
      @$("#new-budget-account-group .dropdown-menu").append $account

    MyCoins.transactionCategoriesCollection.each (category)=>
      $category = $(@templateTransactionCategory)
      $category.attr "data-category-id", category.get "id"
      $category.find("span").text category.get "name"
      @$("#new-budget-category-group .dropdown-menu").append $category


    @$('.input-group.date').datepicker
      format: "yyyy/mm/dd"
      autoclose: true
      todayHighlight: true

    @$('.input-group.date').datepicker "update", Date.create().format "yyyy/mm/dd"

    if @mode == "new"
      @$('header').text "Editing a Budget"
      category = ""
      switch @model.get("categoriesId").length
        when 0 then category = "All"
        when 1 then category = MyCoins.transactionCategoriesCollection.get @model.get("categoriesId")[0]
        else category = "Various"
      @$("#new-budget-category-group .btn:first-of-type .text")
        .text(category)
      @$("#new-transaction-amount").val @model.get("amount").format()
      @$('.input-group.date').datepicker "update", Date.create(@model.get("date")).format "{yyyy}/{MM}/{dd}"



    $("body").on "click", (ev)=>
      @$(".btn-group").removeClass "open"

    return @