
import "./src/jquery.js" //need to put code in separate file due to javascript "hoisting" of import lines to beginning of file
import "jquery-ui"

// I couldn't get this working, so I'm including select2 via a script tag in app/views/layouts/application.html.erb instead
//import "select2"
//import "select2/dist/js/select2"

import "@hotwired/turbo-rails"
import "bootstrap"

import '@fortawesome/fontawesome-free/js/fontawesome'
import '@fortawesome/fontawesome-free/js/solid'

import "trix"

import "activestorage"

import "./change_log_entries.js"
import "./filter.js"
import "./rulemakings.js"
import "./text_from_comments.js"
import "./select2_initializer.js"
import "./trix_customization.js"