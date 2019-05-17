ready = ->
  $('.bootstrap-multiselect').multiselect
    enableCaseInsensitiveFiltering: true,
    delimiterText: '\n',
    maxHeight: 300,
    buttonText: (options, select) ->
      if options.length == 0
        "No Suggested Changes selected <b class='caret'></b>"
      else if options.length > 20
        options.length + " Suggested Changes selected <b class='caret'></b>"
      else
        firstRow = options.length + " Suggested Changes selected <b class='caret'></b>"
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
