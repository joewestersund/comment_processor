ready = ->
  init_multiselect =  () ->
  $('#comment_categories_multiselect').multiselect();

$(document).on('turbolinks:load', ready)
