var add_select2;
var remove_existing_select2;

add_select2 = function () {
    var item_data, firstRow, labels, pluralize;
    item_data = $('.select2-multiselect').data();
    $('.select2-multiselect').select2({
        theme: "bootstrap-5",
        placeholder: 'Select a ' + item_data.entityname + ', type here to search',
        width: 'resolve'
    })
};

remove_existing_select2 = function () {
    $('.select2-multiselect').select2('destroy');
};

$(document).on('turbo:load', add_select2);
$(document).on("turbo:before-cache", remove_existing_select2);
