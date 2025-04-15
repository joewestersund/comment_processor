var ready, ready2;

ready = function() {
    return $('#clear_filter').on('click', function() {
        var url;
        url = $("form:first").attr("action"); // the page name, with no params
        return window.location.href = url;
    });
};

ready2 = function() {
    return $('#show_filter').on('click', function() {
        return $('.filter').toggleClass('hidden');
    });
};

$(document).on('turbolinks:load', ready);
$(document).on('turbolinks:load', ready2);