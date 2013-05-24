# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.youtubeForm = {}

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

#####
# Wavenique YouTube form.
$ ->
  # Returns checkbox id of respective autocompleted inputs.
  getMarkerField = (textfield_id) ->
    marker_id = textfield_id.replace(/(t|n)$/, 'id')
    'input#' + marker_id

  # When autocompleted inputs are overrode.
  null_autocomplete = (event) ->
    # Ignore on the following keys...
    ignoreKeys = [13, 37, 38, 39, 40, 27, 9, 16, 17, 18, 19, 20, 33, 34, 35, 36, 45]
    return for key in ignoreKeys when event.which is key
    # Else, null autocomplete.
    $(this).removeClass('existing')
    marker = $(getMarkerField($(this).attr('id')))
    marker.val('')

  # Autocomplete block for Compositions.
  comp_autocomplete =
    source: (value, response) ->
      $.getJSON '/compositions', find: value.term, (data, status, xhr) ->
        response($.map(data, (item) -> {
          label: item.title
          value: item.title
          composition_id: item.id # To return composition.main when implemented.
        }))
    minLength: 2
    select: (event, ui) ->
      if ui.item
        $(event.target).addClass('existing')
        marker = $(getMarkerField(event.target.id))
        marker.val(ui.item.composition_id)
    autoFocus: true

  # Autocomplete block for Artists.
  artist_autocomplete =
    source: (value, response) ->
      $.getJSON '/artists', find: value.term, (data, status, xhr) ->
        response($.map(data, (item) -> {
          label: item.name
          value: item.name
          artist_id: item.id # To return artist.main when implemented.
        }))
    minLength: 2
    select: (event, ui) ->
      if ui.item
        $(event.target).addClass('existing')
        marker = $(getMarkerField(event.target.id))
        marker.val(ui.item.artist_id)
    autoFocus: true

  # Replace children indexes.
  replace_indexes = (element, perfId, elementId) ->
    toReplace = $(element).html().replace(/((comp|artist)(_|\[))[0-9]+/g, "$1" + elementId)
    toReplace = toReplace.replace(/(perf(_|\[))[0-9]+/g, "$1" + perfId)
    element.html(toReplace)

  # Common add elements function.
  add_element = (caller, source, destination) ->
    cloned = $(source).first().clone() # Clones template fieldset.
    count = caller.data('count') + 1 # Readies count number to index new fields.
    if caller.data('perf-id') # If adding compositions or artists...
      perfId = caller.data('perf-id')
      replace_indexes(cloned, perfId, count)
    else # If adding performances...
      replace_indexes(cloned, count, 1)
      cloned.find('button').data('perf-id', count)
      cloned.removeClass('hidden')
    caller.data('count', count) # Replace button count data.
    destination.append(cloned) # Insert cloned template.
    cloned.find('input').first().focus()
    youtubeForm.apply_interactions()

  # Apply methods to respective text inputs.
  window.youtubeForm.apply_interactions = ->
    $('input.comp-autocomplete').autocomplete(comp_autocomplete).keyup(null_autocomplete)
    $('input.artist-autocomplete').autocomplete(artist_autocomplete).keyup(null_autocomplete)
    $('button').unbind('click')
    $('button.add-composition').click -> add_element($(this), $('.hidden').find('.comp-fields'), $(this).parent().siblings('.fields').first())
    $('button.add-artist').click -> add_element($(this), $('.hidden').find('.artist-fields'), $(this).parent().siblings('.fields').first())
    $('button.add-performance').click -> add_element($(this), $('.hidden'), $(this).siblings('div.form-performances').last())
    $('#close').click ->
      $('#form_container').empty()
      $('#warnings_errors').empty()

  # Initialization.
  #apply_interactions()
