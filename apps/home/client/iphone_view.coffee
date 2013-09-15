Backbone = require 'backbone'
_ = require 'underscore'

module.exports = class iPhoneView extends Backbone.View

  minTop: 100
  minLeft: 50
  maxHeight: 807
  phoneHeightToWidthRatio: 0.4733
  phoneContentAreaHeightRatio: 0.7053
  phoneAreaAboveContentAreaToHeightRatio: 0.14759

  initialize: ->
    @$window = $(window)
    @$phoneContent = @$('.iphone-content')
    @$splashImages = $('.splash-image')
    @$mainPhoneContentAreas = $('#content .phone-content-area')
    @positionPhone()
    @$window.on 'resize.feed', _.throttle((=> @positionPhone()), 70)

  positionPhone: ->
    windowHeight = @$window.height()
    windowWidth = @$window.width()

    @height = windowHeight - (@minTop * 2)
    @height = if @height > @maxHeight then @maxHeight else @height

    @$el.height @height
    @width = Math.floor(@height * @phoneHeightToWidthRatio)

    top = Math.round((windowHeight - @height) / 2)
    left = Math.floor((windowWidth - @width) / 2)

    @top = _.max([top, @minTop])
    @left = _.max([left, @minLeft])

    @$el.css
      top: @top
      left: @left
      width: @width

    @sizeIphoneContentAreas()
    @trigger 'repositioned'

  sizeIphoneContentAreas: ->
    @contentAreaTop = @height * @phoneAreaAboveContentAreaToHeightRatio
    @contentAreaHeight = @height * @phoneContentAreaHeightRatio

    @$phoneContent.css
      height: @contentAreaHeight
      top: @contentAreaTop

    # ideally this would be sized purely by css but we need to shrink the container for wipe animations
    @$splashImages.css
      height: @height * @phoneContentAreaHeightRatio

    @$mainPhoneContentAreas.css
      width: @width
