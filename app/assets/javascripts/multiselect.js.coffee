ready = ->
  $('.bootstrap-multiselect').multiselect
    enableCaseInsensitiveFiltering: true,
    delimiterText: '\n',
    maxHeight: 300,
    buttonText: (options, select) ->
      entity_name = $('.bootstrap-multiselect').data()
      if options.length == 0
        "No " + entity_name.entityname + "s selected <b class='caret'></b>"
      else if options.length > 20
        options.length + " " + entity_name.entityname + "s selected <b class='caret'></b>"
      else
        pluralize = if options.length == 1 then "" else "s"
        firstRow = options.length + " " + entity_name.entityname + pluralize + " selected <b class='caret'></b>"
        labels = [firstRow]
        options.each ->
          if $(this).attr('label') != undefined
            labels.push '- ' + $(this).attr('label')
          else
            labels.push '- ' + $(this).html()
          return
        labels.join('<br>') + ''

ready2 = ->
  $('*:not(.bootstrap-select) > .selectpicker').selectpicker('refresh')

$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:load', ready2)
