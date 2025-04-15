var ready, ready2;

ready = function() {
    return $('.bootstrap-multiselect').multiselect({
        enableCaseInsensitiveFiltering: true,
        delimiterText: '\n',
        maxHeight: 300,
        buttonText: function(options, select) {
            var entity_name, firstRow, labels, pluralize;
            entity_name = $('.bootstrap-multiselect').data();
            if (options.length === 0) {
                return "No " + entity_name.entityname + "s selected <b class='caret'></b>";
            } else if (options.length > 20) {
                return options.length + " " + entity_name.entityname + "s selected <b class='caret'></b>";
            } else {
                pluralize = options.length === 1 ? "" : "s";
                firstRow = options.length + " " + entity_name.entityname + pluralize + " selected <b class='caret'></b>";
                labels = [firstRow];
                options.each(function() {
                    if ($(this).attr('label') !== void 0) {
                        labels.push('- ' + $(this).attr('label'));
                    } else {
                        labels.push('- ' + $(this).html());
                    }
                });
                return labels.join('<br>') + '';
            }
        }
    });
};

ready2 = function() {
    return $('*:not(.bootstrap-select) > .selectpicker').selectpicker('refresh');
};

$(document).on('turbolinks:load', ready);
$(document).on('turbolinks:load', ready2);
