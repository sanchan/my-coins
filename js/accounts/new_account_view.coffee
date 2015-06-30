MyCoins.Views.Accounts ||= {}

class MyCoins.Views.Accounts.NewView extends Backbone.View
  template: """
    <article id="new-account-article">
      <div class="box">
        <p>First, start creating a new account (the place where incomes and expenses go)<p>
        <button id="new-account-btn" class="btn btn-default">New Account</button>
      </div>
    </article>
  """

  events:
    "click #new-account-btn": "newAccount"

  initialize: (options)->
    MyCoins.currentView = @

  newAccount: (ev)->
    @newModalAccountView = new MyCoins.Views.Accounts.NewModalView
    MyCoins.setCurrentModalView @newModalAccountView

    @newModalAccountView.show()

  render: ->
    $("#my-coins-app").attr "data-content-view", "accounts:new"
    @$el.append @template
    @$el.find("#new-modal-account").hide()

    return @