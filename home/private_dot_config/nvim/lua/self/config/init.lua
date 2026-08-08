require('self.config.options')

require('self.config.maps')

require('self.config.autocmds')

require('self.modules.smart_relativenumber').setup { scroll_debounce_ms = 700 }
