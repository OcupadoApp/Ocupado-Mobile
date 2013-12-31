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

    @navView = new Ocupado.Views.RoomsNavView
      collection: @collection

  addRoom: (room) ->
    roomView = new Ocupado.Views.RoomView
      model: room
      parentView: this
    @$el.append roomView.render().el
    if not Ocupado.scroller?
      setTimeout =>
        Ocupado.scroller = new IScroll document.getElementById('OcupadoWrapper'),
          scrollX: true
          snap: 'section'
          momentum: false
          click: true
          probeType: 3
        Ocupado.navScroller = new IScroll $('nav').get(0),
          scrollX: true
          click: true
        ctx = this
        Ocupado.scroller.on 'scroll', -> ctx.navView.scrollTo @x/2
        Ocupado.scroller.on 'scrollEnd', -> ctx.navView.scrollTo @x/2
      , 0

  resetRooms: (rooms) ->
    @$el.html('')
    @collection.each @addRoom, @

