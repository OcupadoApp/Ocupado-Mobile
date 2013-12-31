'use strict';

class Ocupado.Models.EventModel extends Backbone.RelationalModel

  timeRemaining: false
  intervalRef: false

  initialize: ->
    if @get('isNew')?
      @assembleResource()
    else
      @on 'event:start', @eventStart, this
      @on 'event:end', @eventEnd, this

      @set 'creatorImage', @creatorImagePath()

      if @isOccurring()
        @trigger 'event:start'
      else if @isUpcoming()
        @eventUpcoming()

  eventStart: ->
    # Fire the event:end event once the time remaining ends
    remaining = @get('endDate') - Date.now()
    setTimeout =>
      @trigger 'event:end'
    , remaining

    # Set interval to update time remaining
    clearInterval(@intervalRef) if @intervalRef
    @intervalRef = setInterval =>
      @timeRemaining = @get('endDate') - Date.now()
    , 50
    @get('room').trigger('update')

  eventUpcoming: ->
    # Fire 'event:start' when the time comes
    setTimeout =>
      @trigger 'event:start'
    , @get('startDate') - Date.now()

    # Set interval to update time remaining
    @intervalRef = setInterval =>
      @timeRemaining = @get('startDate') - Date.now()
    , 50

  eventEnd: ->
    clearInterval @intervalRef
    thisRoom = @get('room')
    @collection.remove(this)
    thisRoom.trigger('update')

  creatorImagePath: ->
    "http://www.gravatar.com/avatar/#{md5(@get('creatorEmail'))}?s=220"

  isOccurring: ->
    @get('startDate') <= Date.now() <= @get('endDate')

  isUpcoming: ->
    inOneHour = (new Date()).addHours(1).getTime()
    @get('startDate') <= inOneHour and @get('startDate') > Date.now()

  assembleResource: ->
    resource =
      summary: "Room booked by Ocupado: #{@get('room').get('name')}"
      location: "Room: #{@get('room').get('name')}"
      start:
        dateTime: (new Date()).toISOString()
      end:
        dateTime: (new Date()).addMinutes(@get('duration')).toISOString()
      attendees: [
        email: @get('room').get('calendarId')
      ]
    @insertEvent(resource)

  insertEvent: (resource) ->
    request = gapi.client.calendar.events.insert
      calendarId: 'primary'
      resource: resource
    request.execute @onEventInsertion
    @get('dialogView').loading true

  onEventInsertion: (resp) =>
    @get('room').fetch()
    @get('room').once 'update', =>
      setTimeout =>
        @get('dialogView').loading false
      , 100

