@waitFor = (variables, callback) ->
  loaded = []
  for variable in variables
    loaded.push switch variable
      when "jquery"        then @jQuery?
      when "velocity"      then @jQuery.Velocity?
      when "vibrant"       then @Vibrant?
      when "circular-json" then @CircularJSON?
  if loaded.indexOf(false) >= 0
  then setTimeout (-> waitFor(variables, callback)), 10
  else callback()

class UI
  isActive: false

  constructor: ->
    window.addEventListener 'BettrLink::Attached', =>
      @attachComponents()

    window.waitFor ['jquery'], =>
      @injectComponents()

  ### Helpers ######################################

  shadowDOM: ->
    $(document.querySelector('bettrlink-ui').shadowRoot)

  details: ->
    container: @shadowDOM().find('section')
    iframe: @shadowDOM().find('section iframe')

  sidebar: ->
    container: @shadowDOM().find('aside')
    iframe: @shadowDOM().find('aside iframe')

  getView: (view) ->
    chrome.extension.getURL "views/#{view}.html"

  ### Controls #####################################

  open: ->
    @details().container.velocity { opacity: 1 },
      duration: 650, display: 'block', begin: =>
        $('html').css overflow: 'hidden'
    @sidebar().container.velocity { translateX: ["0px","400px"] },
      duration: 435, easing: [0.175, 0.885, 0.32, 1.275]
    @isActive = true

  close: ->
    @details().container.velocity { opacity: 0 },
      duration: 500, display: 'none', complete: =>
        $('html').css overflow: 'initial'
    @sidebar().container.velocity { translateX: ["400px","0px"] },
      duration: 500, easing: "ease-out"
    @isActive = false

  ### Web Components ###############################

  injectComponents: ->
    $('body').append "<bettrlink-ui></bettrlink-ui>"
    $('head').append "<link rel='import' href='#{@getView('components')}'>"

  attachComponents: ->
    @details().iframe.attr 'src', @getView('details/index')
    @sidebar().iframe.attr 'src', @getView('sidebar/index')
    window.trigger 'captureTabAndOpen'

####################################################
# Initialize
####################################################

@BettrLink ||= {}
@BettrLink.UI = new UI()
