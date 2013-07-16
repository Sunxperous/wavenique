# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#####
# Form::Performance
window.formPerformance = {}
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
    $(this).removeClass('formp-existing')
    marker = $(getMarkerField($(this).attr('id')))
    marker.val('')

  # Autocomplete block for Compositions.
  c_autocomplete =
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
        $(event.target).addClass('formp-existing')
        marker = $(getMarkerField(event.target.id))
        marker.val(ui.item.composition_id)
    autoFocus: true

  # Autocomplete block for Artists.
  a_autocomplete =
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
        $(event.target).addClass('formp-existing')
        marker = $(getMarkerField(event.target.id))
        marker.val(ui.item.artist_id)
    autoFocus: true

  # Replace indexes of children and self.
  replace_indexes = (element, pId, elementId) ->
    toReplace = $(element).wrap('<div />').parent().html().replace(/((c|a)(_|\[))[0-9]+/g, "$1" + elementId)
    toReplace = toReplace.replace(/(p(_|\[))[0-9]+/g, "$1" + pId)
    element.html(toReplace)

  # Common add elements function.
  add_element = (caller, source, destination) ->
    cloned = $(source).first().clone() # Clones template fieldset.
    count = caller.data('count') + 1 # Readies count number to index new fields.
    if caller.data('p-id') # If adding compositions or artists...
      pId = caller.data('p-id')
      replace_indexes(cloned, pId, count)
    else # If adding performances...
      replace_indexes(cloned, count, 1)
      cloned.find('button').data('p-id', count)
      cloned.removeClass('hidden')
    caller.data('count', count) # Replace button count data.
    destination.append(cloned) # Insert cloned template.
    new_field = cloned.find('input').first()
    cloned.children().first().unwrap() # Remove parent p[0] element.
    new_field.focus()
    formPerformance.apply_interactions()

  # Apply methods to respective text inputs.
  window.formPerformance.apply_interactions = ->
    $('input.formp-title-autocomplete').autocomplete(c_autocomplete).
      keyup(null_autocomplete)
    $('input.formp-artist-autocomplete').autocomplete(a_autocomplete).
      keyup(null_autocomplete)
    $('button').unbind('click')
    $('button.formp-add-title').click -> add_element($(this), $('.hidden').find('.formp-title-group'), $(this).parent().siblings('fieldset'))
    $('button.formp-add-artist').click -> add_element($(this), $('.hidden').find('.formp-artist-group'), $(this).parent().siblings('fieldset'))
    $('button#formp_add_performance').click -> add_element($(this), $('.hidden').find('.formp-performances-wrap').children(), $(this).siblings('.formp-performances-wrap'))

  window.formPerformance.apply_interactions()
