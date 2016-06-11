jsdom = require('jsdom').jsdom
global.document = jsdom('<html><body></body></html>')
global.window = document.defaultView
global.navigate = window.navigator
global.$ = require('jquery')(window)
Backbone = require('backbone')
Backbone.$ = global.$
