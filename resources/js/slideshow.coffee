document.addEventListener "DOMContentLoaded", ->
  console.log($('body').height())
  # ---------------------------------------------------------------
  # functions for mobile toggle controls
  if hasTouch()
    $('.slideshow').removeClass('hasHover')
    $('.slideshow').on 'touchend', (event)->
      $this = $(event.target).closest('.slideshow')
      $buttons = $($this).find('.button-wrapper')
      if $buttons.hasClass('toggle')
        $buttons.removeClass('toggle')
        return
      $('.button-wrapper.toggle').removeClass('toggle')
      $buttons.addClass('toggle')

  # ---------------------------------------------------------------
  timeoutFunctions = [] #holds the variables for timeout funtion

  # function changes slides in targetSlideshow
  window.changeSlide = (change=1, targetSlideshow, manuelChange=false) ->
    targetSlideshow = $(targetSlideshow).closest('.slideshow')
    current = parseInt(targetSlideshow.attr('current'))
    length = targetSlideshow.data('length')
    index = parseInt(targetSlideshow.data('index'))
    targetSlideshow.find('[data-pos='+current+']').removeClass('active')
    current = if current+change < 0 then length-1 else (current+change)%length
    targetSlideshow.find('[data-pos='+current+']').addClass('active')
    targetSlideshow.attr('current', current)
    if manuelChange # pause if manuel change
      clearTimeout(timeoutFunctions[index])
      targetSlideshow.addClass('pause')
      return ''
    speed = targetSlideshow.data('speed')
    timeoutFunctions[index] = setTimeout(changeSlide,speed, change, targetSlideshow, manuelChange)

  # autostart slidesshows who do not have pause
  # and mobile setup
  $('.slideshow').each (index) ->
    $(this).attr('data-index', index)
    timeoutFunction = ''
    timeoutFunctions.push(timeoutFunction)
    if $(this).hasClass('pause') then return
    changeSlide(1, this, false)
    return
