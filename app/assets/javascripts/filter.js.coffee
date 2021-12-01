ready = ->
  $('#clear_filter').on 'click', () ->
    url = $("form:first").attr("action") # the page name, with no params
    window.location.href = url

ready2 = ->
  $('#show_filter').on 'click', () ->
    $('.filter').toggleClass('hidden')

$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:load', ready2)