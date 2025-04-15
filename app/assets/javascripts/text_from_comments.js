var ready;

ready = function() {
    return $('#show_text_from_comments').on('click', function() {
        event.preventDefault();
        return $('.text-from-comments').toggleClass('hidden');
    });
};

$(document).on('turbolinks:load', ready);
