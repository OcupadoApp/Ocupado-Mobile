'use strict';

class Ocupado.Views.NewEventDialogView extends Backbone.View

  template: Ocupado.Templates['app/scripts/templates/newEventDialog.hbs']
  className: 'new-event-dialog'

  initialize: ->
    @$el.on 'click', '.cancel-event', @closeDialog
    @$el.on 'click', '.time-duration-container div', @createEvent
    window.foo = this
    @render()

  render: ->
    @$el.html @template()
    _.defer =>
      @overlay = @$el.find('.modal-overlay')
      @container = @$el.find('.time-duration-container')
      @cancelBtn = @$el.find('.cancel-event')

      @overlay.addClass 'active'
      @container.addClass 'active'
      @cancelBtn.addClass 'active'
    @

  closeDialog: =>
    @container.one 'webkitTransitionEnd transitionEnd', @close
    @container.removeClass 'active'
    @overlay.removeClass 'active'
    @cancelBtn.removeClass 'active'

  close: =>
    @remove()

  createEvent: (e) =>
    duration = parseInt($(e.target).text())
    event = new Ocupado.Models.EventModel
      isNew: true
      room: @model
      duration: duration
      dialogView: this

  loading: (e) ->
    if e
      @container.removeClass 'active'
      @cancelBtn.removeClass 'active'
    else
      @closeDialog()
      setTimeout =>
        @close()
      , 400

