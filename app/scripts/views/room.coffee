'use strict';

class Ocupado.Views.RoomView extends Backbone.View

  template: Ocupado.Templates['app/scripts/templates/room.hbs']

  tagName: 'section'

  initialize: ->
    @listenTo @model, 'update', @render
    @render()
    @$el.on 'click', '.book-room-icon', @openNewEvent

    setInterval =>
      @partialRender()
    , 1000

  partialRender: ->
    @$el.find('.time-remaining').text(@timeRemaining())

  render: ->
    @$el.html @template(@templateData())
    @$el.css
      'min-width': ($(window).width() - 40) + 'px'

    @$el.prop('class', '')
    if @model.isOccupied()
      @$el.addClass('occupied')
    else if @model.isUpcoming()
      @$el.addClass('upcoming')
    else
      @$el.addClass('vacant')

    if Ocupado.scroller?
      setTimeout ->
        Ocupado.scroller.refresh()
      , 0
    @

  templateData: ->
    occupied: @model.isOccupied()
    upcoming: @model.isUpcoming()
    vacant: @model.isVacant()
    timeRemaining: do => @timeRemaining()
    name: @model.get('name')
    event: @model.get('events').sort().first().toJSON() if not @model.isVacant()

  timeRemaining: ->
    unless @model.isVacant()
      remaining = @model.get('events').sort().first().timeRemaining
      toReadableTime(remaining)
    else
      '00:00:00'

  attributes: ->
    'data-calendarid': @model.get('calendarId')

  openNewEvent: =>
    # Unbind and rebind due to bug in iScroll
    @$el.off 'click', '.book-room-icon', @openNewEvent
    _.defer =>
      @$el.on 'click', '.book-room-icon', @openNewEvent

    $('#OcupadoChrome').append $('<div></div>')
    newEventDialog = new Ocupado.Views.NewEventDialogView
      model: @model
      el: $('#OcupadoChrome div:last')

