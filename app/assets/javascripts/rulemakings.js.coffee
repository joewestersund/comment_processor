ready = ->
    $('input#show_pw_links').on 'click', () ->

        $(".reset_pw_link").toggleClass("hide")

$(document).on('turbolinks:load', ready)