var ready;

ready = function () {
    $('.select2-multiselect').select2(
        {theme: "bootstrap-5"}
    );
};

$(document).on('turbo:load', ready);
