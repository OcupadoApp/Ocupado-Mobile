'use strict';

class Ocupado.Views.RoomsNavView extends Backbone.View

  template: Ocupado.Templates['app/scripts/templates/roomsNav.hbs']
  el: $('nav ul').get(0)

  initialize: ->
    @render()
    @listenTo @collection, 'add reset update', @render
    @$el.find('li').on 'click', @onNavClick

  onNavClick: (e) ->
    e.preventDefault()
    cid = $(this).data('calendarid')
    console.log 'here', cid
    Ocupado.scroller.scrollToElement $("section[data-calendarid='#{cid}']").get(0)

  render: ->
    @$el.find('li').off 'click', @onNavClick
    @$el.html @template
      rooms: @collection.toJSON()

    _.defer =>
      itemWidth = $('#OcupadoApp section:first').width()/2
      listItems = @$el.find('li')
      @$el.find('li').on 'click', @onNavClick
      listItems.css('width', itemWidth + 'px')
      @$el.css('width', (itemWidth * listItems.length) + 'px')
    @

