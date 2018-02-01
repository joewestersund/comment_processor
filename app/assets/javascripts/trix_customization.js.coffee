Trix.config.textAttributes.red =
  style: color: 'red'
  parser: (element) ->
    element.style.color == 'red'
  inheritable: true

Trix.config.textAttributes.blue =
  style: color: 'blue'
  parser: (element) ->
    element.style.color == 'blue'
  inheritable: true

ready = ->
  document.addEventListener 'trix-initialize', (event) ->
    buttonHTML = '<button type="button" data-trix-attribute="red">Red</button>'
    buttonHTML += '<button type="button" data-trix-attribute="blue">Blue</button>'
    event.target.toolbarElement.querySelector('.trix-button-group--text-tools').insertAdjacentHTML 'beforeend', buttonHTML
    return

# don't do on turbolinks:load, otherwise multiple copies of the buttons get added.
$(document).on('ready', ready)
