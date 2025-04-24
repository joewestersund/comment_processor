var ready;

Trix.config.textAttributes.red = {
    style: {
        color: 'red'
    },
    parser: function(element) {
        return element.style.color === 'red';
    },
    inheritable: true
};

Trix.config.textAttributes.blue = {
    style: {
        color: 'blue'
    },
    parser: function(element) {
        return element.style.color === 'blue';
    },
    inheritable: true
};

ready = function() {
    return document.addEventListener('trix-initialize', function(event) {
        var buttonHTML;
        if (!event.target.toolbarElement.querySelector('.trix-button-group--text-tools').querySelector('[data-trix-attribute="red"]')) {
            //if querySelector returns null, then buttons aren't there yet and we should add.
            //if this if statement is left out, hitting the back button can result in multiple copies of the buttons.
            buttonHTML = '<button type="button" data-trix-attribute="red">Red</button>';
            buttonHTML += '<button type="button" data-trix-attribute="blue">Blue</button>';
            event.target.toolbarElement.querySelector('.trix-button-group--text-tools').insertAdjacentHTML('beforeend', buttonHTML);
        }
    });
};

$(document).on('turbo:load', ready);
$(document).on('turbo:render', ready); //needed so that buttons are added when user hits save and page redirects to self