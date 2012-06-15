class PhoneCatalog.Views.Search extends PhoneCatalog.Views.FadingView

  template: JST['search/search']

  events:
    "submit form": "search"
    "change form select": "search"
    "change form input:radio": "search"

  initialize: () ->
    super
    @phonesView = new PhoneCatalog.Views.PhonesIndex(display: false)
    @phonesPager = new PhoneCatalog.Views.Pager(collection: @phonesView.collection)

  render: ->
    @$el.html(@template(options: @options))
    @$('#pager').append(@phonesPager.el)
    @$('#results').empty()
    @$('#results').append(@phonesView.el)
    @

  search: (event) ->
    event?.preventDefault()
    params = {}
    for p in ("#{r}_id" for r in PhoneCatalog.Models.Phone.referenceProperties())
      params[p] = @$("select[name='#{p}']").val()
    for p in PhoneCatalog.Models.Phone.booleanProperties()
      params[p] = @$("input:radio[name='#{p}']:checked").val()
    @phonesView.collection.fetchByParams params