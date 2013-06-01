$ ->
  artist_merge_options =
    source: (value, response) ->
      $.getJSON '/artists/find', name: value.term, (data, status, xhr) ->
        response($.map(data, (item) -> {
          label: item.name
          value: item.name
          artist_id: item.id # To return artist.main when implemented.
        }))
    minLength: 2
    select: (event, ui) ->
      if ui.item
        $(event.target).siblings('input[type="hidden"]').val(ui.item.artist_id)
        $(event.target).siblings('input[type="submit"]').prop('disabled', false)
    autoFocus: true
  
  $('#artist_merge').autocomplete artist_merge_options

