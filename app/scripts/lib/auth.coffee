window.handleClientLoad = ->
  clientLoaded.resolve()
# window.handleClientLoad= ->
#   gapi.client.setApiKey Ocupado.config.apiKey
#   window.setTimeout Ocupado.Auth.checkAuth, 1
# 
# window.Ocupado.Auth =
#   isAuthenticated: false
# 
#   checkAuth: ->
#     gapi.auth.authorize
#       client_id: Ocupado.config.clientId
#       scope: Ocupado.config.scopes
#       immediate: true
#     , Ocupado.Auth.handleAuthResult
# 
#   handleAuthResult: (authResult) ->
#     authBtn = $('#authorizeButton')
#     if authResult and not authResult.error
#       # Success
#       authBtn.hide()
#       Ocupado.trigger 'ocupado:auth:success'
#       Ocupado.Auth.isAuthenticated = true
#       gapi.client.load 'calendar', 'v3', Ocupado.Auth.calendarAPILoaded
#     else
#       # Auth failed
#       authBtn.show()
#       authBtn.on 'click', ->
#         Ocupado.Auth.handleAuthClick()
#       Ocupado.trigger 'ocupado:auth:failure'
#       Ocupado.Auth.isAuthenticated = false
# 
#   handleAuthClick: ->
#     gapi.auth.authorize
#       client_id: Ocupado.config.clientId
#       scope: Ocupado.config.scopes
#       immediate: false
#     , Ocupado.Auth.handleAuthResult
#     false
# 
#   calendarAPILoaded: ->
#     Ocupado.trigger 'ocupado:auth:calendarloaded'
# 
