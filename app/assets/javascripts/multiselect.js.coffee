ready = ->
  $('.multiselect-dropdown').multiselect
    enableCaseInsensitiveFiltering: true,
    delimiterText: '\n',
    maxHeight: 300,
    buttonText: (options, select) ->
      if options.length == 0
        "No categories selected <b class='caret'></b>"
      else if options.length > 20
        options.length + " categories selected <b class='caret'></b>"
      else
        firstRow = options.length + " categories selected <b class='caret'></b>"
        labels = [firstRow]
        options.each ->
          if $(this).attr('label') != undefined
            labels.push '- ' + $(this).attr('label')
          else
            labels.push '- ' + $(this).html()
          return
        labels.join('<br>') + ''

$(document).on('turbolinks:load', ready)
