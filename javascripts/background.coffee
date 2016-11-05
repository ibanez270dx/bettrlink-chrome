bettrlink = 'window.BettrLink'
page = undefined

#######################################
# Browser Action
#######################################

chrome.browserAction.onClicked.addListener (tab) ->
  injectCode "document.querySelector('bettrlink-ui')!=null", (isLoaded) ->
    return toggleUI() if isLoaded[0]
    loadUI()

loadUI = ->
  injectFile 'javascripts/lib/jquery-2.1.4.min.js'
  injectFile 'javascripts/components/helpers.js'
  injectFile 'javascripts/components/ui.js'

toggleUI = ->
  injectCode "#{bettrlink}.UI.isActive", (isActive) ->
    unless isActive[0]
    then injectCode "#{bettrlink}.UI.open()"
    else injectCode "#{bettrlink}.UI.close()"

#######################################
# Utility
#######################################

injectFile = (file, callback) ->
  chrome.tabs.executeScript null, file: file, (result) ->
    callback(result) if callback?

injectCode = (code, callback) ->
  chrome.tabs.executeScript null, code: code, (result) ->
    callback(result) if callback?
