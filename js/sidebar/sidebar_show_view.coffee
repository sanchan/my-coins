MyCoins.Views.Sidebar ||= {}

class MyCoins.Views.Sidebar.ShowView extends Backbone.View
  template: """
    <ul id="app-sidebar-nav" class="sidebar-nav nav">
      <li id="sidebar-accounts" class="sidebar-item">
        <a href="#sidebar-accounts">
          <i class="fa fa-university"></i>
          <span>Accounts</span>
        </a>
        <div id="sidebar-accounts-nav-wrapper">
        <ul id="sidebar-accounts-nav" class="nav sub-nav"></ul>
        </div>
      </li>
      <li id="sidebar-budgets" class="sidebar-item">
        <a href="#sidebar-budgets">
          <i class="fa fa-money"></i>
          <span>Budgets</span>
        </a>
        <div id="sidebar-budgets-nav-wrapper">
          <ul id="sidebar-budgets-nav" class="nav sub-nav"></ul>
        </div>
      </li>
      <li id="sidebar-scheduled" class="sidebar-item">
        <a href="#sidebar-scheduled">
          <i class="fa fa-clock-o"></i>
          <span>Scheduled</span>
        </a>
        <ul id="sidebar-scheduled-nav" class="nav sub-nav"></ul>
      </li>
      <li id="sidebar-reports" class="sidebar-item">
        <a href="#sidebar-reports">
          <i class="fa fa-bar-chart"></i>
          <span>Reports</span>
        </a>
        <ul id="sidebar-reports-nav" class="nav sub-nav"></ul>
      </li>
    </ul>
    <footer id="app-sidebar-footer">
      <div id="app-sidebar-footer-new-group" class="btn-group dropup">
        <button type="button" class="btn btn-default"><span class="fa fa-plus"></span><span class="sr-only">List View</span></button>
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
          <span class="caret"></span>
          <span class="sr-only">List View</span>
        </button>
        <ul class="dropdown-menu" role="menu">
          <li id="app-sidebar-footer-new-account"><a href="#">New Account</a></li>
          <li id="app-sidebar-footer-new-budget"><a href="#">New Budget</a></li>
        </ul>
      </div>
    </footer>
  """

  events:
    "click .sidebar-item": "sidebarItemClicked"
    "click #app-sidebar-footer-new-group .btn": "toggleNewPopup"
    "click #app-sidebar-footer-new-account": "newAccount"
    "click #app-sidebar-footer-new-budget": "newBudget"

  initialize: (options)->
    MyCoins.accountsCollection.on "add", (account)=>
      @addAccount(account)

    MyCoins.accountsCollection.on "reset", (collection)=>
      collection.each (account) =>
        @addAccount(account)

    MyCoins.accountsCollection.fetch reset: true

  newAccount: (ev)->
    @newAccountModalView = new MyCoins.Views.Accounts.NewModalView
    MyCoins.setCurrentModalView @newAccountModalView

    @newAccountModalView.show()

  newBudget: (ev)->
    @newBudgetModalView = new MyCoins.Views.Budgets.NewBudgetModalView
    MyCoins.setCurrentModalView @newBudgetModalView

    @newBudgetModalView.show()

  toggleNewPopup: (ev)->
    ev.stopPropagation()
    @$("#app-sidebar-footer-new-group").toggleClass "open"

  sidebarItemClicked: (ev) ->
    @$el.find(".sidebar-item").removeClass "active"
    $(ev.target).closest(".sidebar-item").addClass "active"

  addAccount: (accountModel) ->
    account = new MyCoins.Views.Sidebar.AccountView
      model: accountModel

    @$("#sidebar-accounts-nav").append account.render().el

  render: ->
    @$el.append @template

    $("body").on "click", (ev)=>
      @$(".btn-group").removeClass "open"

    @$el.find("#sidebar-accounts").addClass "active"

    MyCoins.accountsCollection.each (account) =>
      @addAccount(account)

    @$(".account-item").first().addClass "active"


    return @