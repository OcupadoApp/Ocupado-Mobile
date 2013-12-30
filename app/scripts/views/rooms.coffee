'use strict';

class Ocupado.Views.RoomsView extends Backbone.View

  el: '#OcupadoApp'
  template: Ocupado.Templates['app/scripts/templates/rooms.hbs']

  initialize: ->
    @listenTo @collection, 'add', @addRoom
    @listenTo @collection, 'reset', @resetRooms
    @listenTo @collection, 'update', @roomUpdate

    Handlebars.registerPartial('occupied', Ocupado.Templates.occupied)
    Handlebars.registerPartial('upcoming', Ocupado.Templates.upcoming)
    Handlebars.registerPartial('vacant', Ocupado.Templates.vacant)

  addRoom: (room) ->
    roomView = new Ocupado.Views.RoomView
      model: room
      parentView: this
    @$el.append roomView.render().el
    if not Ocupado.scroller?
      Ocupado.scroller = new IScroll document.getElementById('OcupadoWrapper'),
        scrollX: true
        snap: 'section'

  resetRooms: (rooms) ->
    @$el.html('')
    @collection.each @addRoom, @
    console.log 'set'

