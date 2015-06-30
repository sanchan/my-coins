MyCoins.Views.Sidebar ||= {}

class MyCoins.Views.Sidebar.AccountView extends Backbone.View
  tagName: "li"
  template: """<a href="#"><span class="name"></span><span class="balance"></span>"""

  events:
    "click": "accountClicked"

  initialize: (options)->
    MyCoins.transactionsCollection.on "add remove change reset", =>
      @updateBalanceText()

  accountClicked: (ev) ->
    $(".account-item").removeClass "active"
    $(ev.target).closest(".account-item").addClass "active"

  updateBalanceText: ()->
    balance = @model.balance()
    @$(".balance").text balance.format() + " " + @model.get("currency")

  render: () ->
    @$el.append @template
    @$el.addClass "account-item"
    @$el.attr "data-account-id", @model.get("id")
    @$(".name").text @model.get("name")
    @$(".balance").text Number(@model.balance()).format() + " " + @model.get("currency")
    @$("a").attr 'href', "account/" + @model.get("id") + "/show"

    return @