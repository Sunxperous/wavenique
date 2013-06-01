$ ->
  composition_merge_options =
    source: (value, response) ->
      $.getJSON '/compositions/find', title: value.term, (data, status, xhr) ->
        response($.map(data, (item) -> {
          label: item.title
          value: item.title
          composition_id: item.id # To return composition.main when implemented.
        }))
    minLength: 2
    select: (event, ui) ->
      if ui.item
        $(event.target).siblings('input[type="hidden"]').val(ui.item.composition_id)
        $(event.target).siblings('input[type="submit"]').prop('disabled', false)
    autoFocus: true
  
  $('#composition_merge').autocomplete composition_merge_options

