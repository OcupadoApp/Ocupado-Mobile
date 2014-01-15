window.clientLoaded = $.Deferred()
window.calendarApiLoaded = $.Deferred()

window.handleClientLoad = ->
  clientLoaded.resolve()

$ ->
  $.when(clientLoaded.promise(), deviceReady.promise()).then ->
    if Ocupado.Auth.tokenIsAvailable()
      $('#authorizeButton').hide()
      dfd = Ocupado.Auth.getToken()
      dfd.done (token) ->
        Ocupado.Auth.setToken token
      gapi.client.load 'calendar', 'v3', Ocupado.Auth.calendarLoaded
    else
      $('#authorizeButton').show().on 'click', ->
        Ocupado.Auth.authorize
          client_id: Ocupado.config.clientId
          client_secret: Ocupado.config.clientSecret
          redirect_uri: 'http://localhost'
          scope: Ocupado.config.scope
        .done (token) ->
          $('#authorizeButton').hide()
          Ocupado.Auth.setToken token
          gapi.client.load 'calendar', 'v3', Ocupado.Auth.calendarLoaded
        .fail (data) ->
          alert 'Auth failed'

window.Ocupado.Auth =
  authorize: (options) ->
    deferred = $.Deferred()

    authUrl = 'https://accounts.google.com/o/oauth2/auth?' + $.param
      client_id: options.client_id
      redirect_uri: options.redirect_uri
      response_type: 'code'
      scope: options.scope

    authWindow = window.open authUrl, '_blank', 'location=no,toolbar=no'

    authWindow.addEventListener 'loadstart', (e) ->
      url = e.url
      code = /\?code=(.+)$/.exec(url)
      error = /\?error=(.+)$/.exec(url)

      if code or error
        authWindow.close()

      if code
        $.post 'https://accounts.google.com/o/oauth2/token',
          code: code[1]
          client_id: options.client_id
          client_secret: options.client_secret
          redirect_uri: options.redirect_uri
          grant_type: 'authorization_code'
        .done (data) ->
          deferred.resolve(data)
        .fail (response) ->
          deferred.reject(response.responseJSON)
      else if error
        deferred.reject
          error: error[1]

    deferred.promise()

  checkAuth: ->
    localStorage.access_token? && localStorage.refresh_token?

  calendarLoaded: ->
    calendarApiLoaded.resolve()
    Ocupado.trigger 'ocupado:auth:calendarloaded'

  setToken: (token) ->
    gapi.auth.setToken token

    localStorage.access_token = token.access_token
    localStorage.refresh_token = token.refresh_token || localStorage.refresh_token

    now = new Date().getTime()
    expiresAt = now + parseInt(token.expires_in, 10) * 1000 - 60000
    localStorage.expires_at = expiresAt

  tokenIsAvailable: ->
    localStorage.access_token?

  getToken: ->
    dfd = $.Deferred()
    now = new Date().getTime()

    if now < localStorage.expires_at
      dfd.resolve
        access_token: localStorage.access_token
    else if localStorage.refresh_token
      $.post 'https://accounts.google.com/o/oauth2/token',
        refresh_token: localStorage.refresh_token
        client_id: Ocupado.config.clientId
        client_secret: Ocupado.config.clientSecret
        grant_type: 'refresh_token'
      .done (data) ->
        Ocupado.Auth.setToken(data)
        dfd.resolve(data)
      .fail (response) ->
        dfd.reject(response.responseJSON)
    else
      dfd.reject()
    dfd.promise()

