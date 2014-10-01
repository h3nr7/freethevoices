
util = require './util.coffee'

extend = ->
    switch arguments.length
        when 1
            util.extend mkk, arguments[0]

        when 2
            pkg = arguments[0]
            mkk[pkg] = {} if not mkk[pkg]?
            util.extend mkk[pkg], arguments[1]

#
# NAMESPACE
# 
mkk = {}

#
# MKK LIBRARY
# 
extend require './color.coffee'


#
# Exports
#
module.exports = mkk

# attach to global window object in browser based environments
window.mkk = mkk if window?



