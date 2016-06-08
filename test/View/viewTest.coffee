jsdom = require('jsdom').jsdom
global.document = jsdom('<html><body></body></html>')
global.window = document.defaultView
global.navigate = window.navigator
$ = require('jquery')(window)
Backbone = require('backbone')
Backbone.$ = $
