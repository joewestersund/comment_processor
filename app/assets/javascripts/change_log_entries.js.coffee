ready = ->
  $('#show_change_log_entries').on 'click', () ->
    $('.change-log-entries').toggleClass('hidden')

$(document).on('turbolinks:load', ready)