var ready;

ready = function () {
    return $('.bootstrap-multiselect').TomSelect({
        maxItems: null
    });
}

$(document).on('turbo:load', ready);
