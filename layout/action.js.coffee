#= require jquery.chrono
#= require jquery.easing
#= require jquery.hoverIntent

after = jQueryChrono.after
every = jQueryChrono.every

jQuery ($) ->
  easings = $('.easings li')

  # Link emulation

  easings.click -> location.hash = $(@).find('.link').attr('href')
  easings.mouseenter -> $(@).addClass('hover')
  easings.mouseleave -> $(@).removeClass('hover')
  easings.mousedown  -> $(@).addClass('pressed')
  easings.mouseup    -> $(@).removeClass('pressed')

  # Allow to copy easing name quicky by double click

  dblclickWaiting = false
  headers = easings.find('h2')

  headers.click ->
    dblclickWaiting = true
    easing = $(@).closest('li')
    after '200ms', ->
      if dblclickWaiting
        easing.click()
        dblclickWaiting = false
    false

  headers.dblclick ->
    dblclickWaiting = false
    location.hash = ''

  # Easing example

  graphBottom = parseInt(easings.find('.example').css('top'))
  graphHeight = easings.height()
  dotX = easings.find('.dot').css('left')
  dotY = easings.find('.dot').css('top')

  easings.hoverIntent
    out: ->
      $(@).find('.example').stop().css(top: graphBottom).end().
           find('.dot').stop().css(top: dotY, left: dotX)
    over: ->
      easing = $(@).find('h2').text()
      $(@).
        find('.example').animate(top: '-=60', 1000, easing).end().
        find('.dot').animate { top: '-=60', left: '+=119'}
          duration: 1000
          specialEasing: top: easing, left: 'linear'

  # Highlight easing

  highlight = ->
    easing = easings.find(".link[href=#{location.hash}]").closest('li')
    if easing.length
      $('.easings').addClass('highlighted')
      easings.removeClass('highlight')
      easing.addClass('highlight')
    else
      $('.easings').removeClass('highlighted')
      easings.removeClass('highlight')

  highlight()
  $(window).on('hashchange', highlight)

  $('body').click ->
    location.hash = '' if location.hash.length > 1

  easings.click ->
    if $(@).hasClass('highlight')
      location.hash = ''
      false