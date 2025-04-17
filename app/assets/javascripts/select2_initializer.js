var ready;

ready = function () {
    var entity_name, firstRow, labels, pluralize;
    entity_name = $('.select2-multiselect').data();
    $('.select2-multiselect').select2({
        theme: "bootstrap-5",
        placeholder: 'Select a ' + entity_name.entityname + ', type here to search',
        width: 'resolve'
    })
};

$(document).on('turbo:load', ready);
