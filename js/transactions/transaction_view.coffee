MyCoins.Views.Transactions ||= {}

class MyCoins.Views.Transactions.TransactionView extends Backbone.View
  tagName: "li"
  template: """
    <div class="body">
      <span class="fa paid paid-check"></span>
      <span class="description"></span>
      <span class="value"></span>
      <span class="date"><i class="fa fa-calendar"></i><span class="text"></span></span>
      <span class="type"></span>
    </div>

    <aside>
      <div class="btn-group">
        <button type="button" class="btn btn-default btn-edit"><span class="fa fa-edit"></span><span class="sr-only">Edit</span></button>
        <button type="button" class="btn btn-default btn-danger btn-delete"><span class="fa fa-remove"></span><span class="sr-only">Delete</span></button>
      </div>
    </aside>
  """

  events:
    "click": "toggleAside"
    "click .paid-check": "togglePaid"
    "click .btn-edit": "editTransaction"
    "click .btn-delete": "removeTransaction"
    "dblclick": "editTransaction"

  editTransaction: (ev)->
    @editModalAccountView = new MyCoins.Views.Transactions.NewTransactionModalView
      model: @model

    MyCoins.setCurrentModalView @editModalAccountView

    @editModalAccountView.show()

  togglePaid: (ev)->
    ev.stopPropagation()
    @model.togglePaid()
    @model.save()

  removeTransaction: ->
    @model.destroy()

  initialize: (options)->

    @model.on "change:accountId", (model, value)=>
      if value != @model.previous "accountId"
        @remove()
        @off()

    @model.on "change:description", (model, value)=>
      @$(".body .description").text @model.get("description")

    @model.on "change:value", (model, value)=>
      @$(".body > .value").text value.format() + " " + @model.get("currency")

    @model.on "change:date", (model, value)=>
      @$(".body .date .text").text Date.create(value).format('{Weekday} {d} {Month}, {yyyy}')

    @model.on "change:type", (model, value)=>
      @$el.removeClass("income").removeClass("expense").addClass model.get "type"

    @model.on "change:paid", (model, value)=>
      @$(".body .paid-check").removeClass("paid").removeClass("unpaid")
      if value
        @$(".body .paid-check").addClass("paid")
      else
        @$(".body .paid-check").addClass("unpaid")

    @model.on "destroy", ()=>
      @remove()
      @off()

  toggleAside: (ev)->
    @$el.toggleClass "selected"

  show: ->
    @$el.fadeIn()

  hide: ->
    @$el.fadeOut()

  render: ->
    @$el.append @template
    if @model.get("paid")
      @$(".body .paid-check").removeClass("unpaid").addClass("paid")
    else
      @$(".body .paid-check").removeClass("paid").addClass("unpaid")
    @$(".description").text @model.get("description")
    @$(".body > .value").text @model.get("value").format() + " " + @model.get("currency")
    @$(".date .text").text Date.create(@model.get("date")).format('{Weekday} {d} {Month}, {yyyy}')
    @$el.addClass "transaction"
    @$el.addClass @model.get("type")

    return @