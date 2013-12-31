'use strict';

class Ocupado.Views.RoomView extends Backbone.View

  template: Ocupado.Templates['app/scripts/templates/room.hbs']

  tagName: 'section'

  initialize: ->
    @listenTo @model, 'update', @render
    @render()

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

