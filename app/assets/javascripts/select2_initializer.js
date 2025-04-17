
document.addEventListener("turbo:load", function() {
    $('.select2-multiselect').select2({
        theme: "bootstrap-5"
    });
});

// Clean up Select2 before Turbo replaces the page
document.addEventListener("turbo:before-render", function() {
    $('.select2-multiselect').select2('destroy');
});

/*
var ready;

ready = function () {
    return $('.select2-multiselect').Select2({
        theme: "bootstrap-5",
    });
}

$(document).on('turbo:load', ready);
*/
