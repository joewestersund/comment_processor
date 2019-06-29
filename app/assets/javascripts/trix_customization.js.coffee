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
    if !event.target.toolbarElement.querySelector('.trix-button-group--text-tools').querySelector('[data-trix-attribute="red"]')
      #if querySelector returns null, then buttons aren't there yet and we should add.
      #if this if statement is left out, hitting the back button can result in multiple copies of the buttons.
      buttonHTML = '<button type="button" data-trix-attribute="red">Red</button>'
      buttonHTML += '<button type="button" data-trix-attribute="blue">Blue</button>'
      event.target.toolbarElement.querySelector('.trix-button-group--text-tools').insertAdjacentHTML 'beforeend', buttonHTML
    return

$(document).on('turbolinks:load', ready)

$(document).on('turbolinks:render', ready) #needed so that buttons are added when user hits save and page redirects to self
