MyCoins.Views.Accounts ||= {}

class MyCoins.Views.Accounts.NewModalView extends Backbone.View
  template: """
    <article id="new-modal-account-article" class="my-coins-modal">
      <header>Select Account Type</header>
      <div class="box">
        <div class="row">
          <input id="new-modal-account-name-input" placeholder="Account Name" type="text">
        </div>

        <div class="row">
          <button id="new-modal-account-cash-btn" class="btn btn-default">Cash Account</button>
        </div>

        <div class="row">
          <button id="new-modal-account-checking-btn" class="btn btn-default">Checking Account</button>
        </div>

        <div class="row">
          <button id="new-modal-account-credit-btn" class="btn btn-default">Credit Account</button>
        </div>

        <div class="row">
          <button id="new-modal-account-savings-btn" class="btn btn-default">Savings Account</button>
        </div>
      </div>
      <footer><button id="new-modal-account-cancel-btn" class="btn btn-default">Cancel</button></footer>
    </article>
  """

  events:
    "click #new-modal-account-checking-btn": "newCheckingAccount"
    "click #new-modal-account-cash-btn": "newCashAccount"
    "click #new-modal-account-credit-btn": "newCreditAccount"
    "click #new-modal-account-savings-btn": "newSavingsAccount"
    "click #new-modal-account-cancel-btn": "hide"

  newAccount: (type) ->
    $name = @$("#new-modal-account-name-input")
    name = $name.val().trim()
    $name.removeClass "error"
    if name == ""
      $name.addClass "error"
    else
      @collection.create
        name: name
        type: type

      @hide()

  newCashAccount: (ev)->
    @newAccount "cash"

  newCheckingAccount: (ev)->
    @newAccount "checking"

  newCreditAccount: (ev)->
    @newAccount "credit"

  newSavingsAccount: (ev)->
    @newAccount "savings"

  initialize: (options)->
    @collection = MyCoins.accountsCollection
    @collection.on "add", (account)->
      Backbone.history.navigate("account/" + account.get("id") + "/show", true)

  show: ->
    $("#app-modal").fadeIn()

  hide: ->
    $("#app-modal").fadeOut()


  render: ->
    @$el.append @template

    return @