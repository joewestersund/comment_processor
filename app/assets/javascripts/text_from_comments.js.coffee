ready = ->
  console.log "text_from_comments is loading"
  $('#show_text_from_comments').on 'click', () ->
    event.preventDefault()
    $('.text-from-comments').toggleClass('hidden')

$(document).on('turbolinks:load', ready)

