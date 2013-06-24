# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


#####
# YouTube Player IFrame API.
root = exports ? this

$(window).load ->
  # Limit to /youtube in the future.
  tag = $('<script>', src: 'https://www.youtube.com/iframe_api')
  $('script').first().before(tag)

$ ->
  player = null
  root.onYouTubeIframeAPIReady = ->
    player = new YT.Player('player', {
      events: {
        'onReady': onPlayerReady
        'onStateChange': onStateChange
      }
    })

  getVideoId = (playing) ->
    playing.getVideoUrl().match(/(\?|\&)v=[0-9a-zA-Z\-_]{11}/g)[0].substr(3,13)

  videoIdSameAsUrl = (playing) ->
    window.location.pathname.match(/[0-9a-zA-Z\-_]{11}/g)[0] == getVideoId(playing)

  onPlayerReady = (event) ->
    event.target.playVideo()
    event.target.pauseVideo()
    
  switched = false
  onStateChange = (event) ->
    # Redirect when a different video loads.
    if event.data == -1 and !videoIdSameAsUrl(player) and !switched
      #player.stopVideo() # Replace this with a future black-out, whatever way you deem fit.
      window.location = 'http://localhost:3000/youtube/' + getVideoId(player)
      switched = true


  # Initialization.
  #apply_interactions()
