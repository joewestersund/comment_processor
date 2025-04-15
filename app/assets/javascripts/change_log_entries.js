var ready;

ready = function() {
    return $('#show_change_log_entries').on('click', function() {
        return $('.change-log-entries').toggleClass('hidden');
    });
};

$(document).on('turbolinks:load', ready);