# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# YouTube Player IFrame API.
root = exports ? this

$(window).load ->
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
    #event.target.pauseVideo()
    
  switched = false
  onStateChange = (event) ->
    if event.data == -1 and !videoIdSameAsUrl(player) and !switched # New video loaded.
      #player.stopVideo() # Replace this with a future black-out, whatever way you deem fit.
      window.location = 'http://localhost:3000/youtube/' + getVideoId(player)
      switched = true

# Wavenique YouTube form.
$ ->
  perf_count = $('div.performance').length
  title_count = $('div.title').length
  name_count = $('div.name').length

  title_autocomplete =
    source: (title, response) ->
      $.getJSON '/titles', find: title.term, (data, status, xhr) ->
        response($.map(data, (item) -> {
          label: item.title
          value: item.title
          composition_id: item.composition_id
        }))
    minLength: 2
    select: (event, ui) ->
      if ui.item
        checkbox = $(getCompIdField(event.target.id))
        checkbox.prop('checked', true).attr('disabled', false).val(ui.item.composition_id)

  getCompIdField = (title_id) ->
    comp_id = title_id.replace(/t$/, 'c_id')
    'input#' + comp_id

  name_autocomplete =
    source: (name, response) ->
      $.getJSON '/names', find: name.term, (data, status, xhr) ->
        response($.map(data, (item) -> {
          label: item.name
          value: item.name
          artist_id: item.artist_id
        }))
    minLength: 2
    select: (event, ui) ->
      if ui.item
        checkbox = $(getArtistIdField(event.target.id))
        checkbox.prop('checked', true).attr('disabled', false).val(ui.item.artist_id)

  getArtistIdField = (name_id) ->
    artist_id = name_id.replace(/n$/, 'a_id')
    'input#' + artist_id

  null_autocomplete = (event) ->
    if $(this).hasClass('name-autocomplete')
      checkbox = $(getArtistIdField($(this).attr('id')))
    else
      checkbox = $(getCompIdField($(this).attr('id')))
    ignoreKeys = [13, 37, 38, 39, 40, 27, 9, 16, 17, 18, 19, 20, 33, 34, 35, 36, 45]
    return for key in ignoreKeys when event.which is key
    checkbox.attr('disabled', true).prop('checked', false).val('')

  $('input.title-autocomplete').autocomplete(title_autocomplete)
  $('input.name-autocomplete').autocomplete(name_autocomplete)
  $('input.title-autocomplete').keyup(null_autocomplete)
  $('input.name-autocomplete').keyup(null_autocomplete)

  $('button.add-title').click (event) ->
    addTitle($(this))

  $('button.add-name').click (event) ->
    addName($(this))

  $('button.add-performance').click (event) ->
    addPerformance($(this))

  addTitle = (add_link) ->
    parent_id = add_link.parent().attr('id')
    title_div_id = 'titles[' + ++title_count + ']'
    new_title_div = $('<div/>', id: title_div_id)
    new_title_text = $('<input>',
      name: parent_id + '[' + title_div_id + '[t]]',
      id: parent_id.replace(/[\[\]]/g, '_') + title_div_id.replace(/[\[\]]/g, '_') + 't',
      class: 'title-autocomplete',
      type: "text"
    )
    new_title_hidden = $('<input>',
      name: parent_id + '[' + title_div_id + '[c_id]]',
      id: parent_id.replace(/[\[\]]/g, '_') + title_div_id.replace(/[\[\]]/g, '_') + 'c_id',
      type: "checkbox"
      disabled: true
      checked: false
    )
    new_title_div.append(new_title_text).append(new_title_hidden)
    add_link.before(new_title_div)
    new_title_text.autocomplete(title_autocomplete)
    new_title_text.keyup(null_autocomplete)

  addName = (add_link) ->
    parent_id = add_link.parent().attr('id')
    name_div_id = 'names[' + ++name_count + ']'
    new_name_div = $('<div/>', id: name_div_id)
    new_name_text = $('<input>',
      name: parent_id + '[' + name_div_id + '[n]]',
      id: parent_id.replace(/[\[\]]/g, '_') + name_div_id.replace(/[\[\]]/g, '_') + 'n',
      class: 'name-autocomplete',
      type: "text"
    )
    new_name_hidden = $('<input>',
      name: parent_id + '[' + name_div_id + '[a_id]]',
      id: parent_id.replace(/[\[\]]/g, '_') + name_div_id.replace(/[\[\]]/g, '_') + 'a_id',
      type: "checkbox"
      disabled: true
      checked: false
    )
    new_name_div.append(new_name_text).append(new_name_hidden)
    add_link.before(new_name_div)
    new_name_text.autocomplete(name_autocomplete)
    new_name_text.keyup(null_autocomplete)

  addPerformance = (add_link) ->
    performance_div_id = 'perf[' + ++perf_count + ']'
    new_performance_div = $('<div/>', id: performance_div_id)
    add_title_button = $('<button/>', html: 'Add title', type: 'button', class: 'add-title')
    add_name_button = $('<button/>', html: 'Add name', type: 'button', class: 'add-name')
    new_performance_div.append(add_title_button)
    new_performance_div.append(add_name_button)
    add_link.before(new_performance_div)
    addTitle(add_title_button)
    add_title_button.click (event) ->
      addTitle($(this))
    addName(add_name_button)
    add_name_button.click (event) ->
      addName($(this))

  
