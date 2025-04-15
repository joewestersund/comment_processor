//= require bootstrap/alert
//= require bootstrap/dropdown

//= require rails-ujs
//= require trix
//= require activestorage

import "jquery/src/jquery.js" //need to put code in separate file due to javascript "hoisting" of import lines to beginning of file
import "jquery-ui"

import "@hotwired/turbo-rails"

import "bootstrap"

import '@fortawesome/fontawesome-free/js/fontawesome'
import '@fortawesome/fontawesome-free/js/solid'

import 'tom-select/dist/js/tom-select.complete.js'

import "./bootstrap_select_fix.js"
import "./cable.js"
import "./change_log_entries.js"
import "./filter.js"
import "./multiselect.js"
import "./rulemakings.js"
import "./text_from_comments.js"
import "./tom_select_initializer.js"
import "./trix_customization.js"