var ready;

ready = function() {
    return $('input#show_pw_links').on('click', function() {
        return $(".reset_pw_link").toggleClass("hide");
    });
};

$(document).on('turbo:load', ready);