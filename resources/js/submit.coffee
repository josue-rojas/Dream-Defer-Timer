---
---



document.addEventListener "DOMContentLoaded", ->
  # date browser cheat-code from https://code.tutsplus.com/tutorials/quick-tip-create-cross-browser-datepickers-in-minutes--net-20236
  elem = document.createElement('input')
  elem.setAttribute('type', 'date');
  if elem.type == 'text'
    $dateInput = $('.date-input')
    $dateInput.datepicker()
    thisDate = new Date()
    $dateInput.attr('value', (thisDate.getMonth()+1) + '/' + thisDate.getDate() + '/' + thisDate.getFullYear() )

  # checks date if valid if so return unix epoch
  checkDate = (date) ->
    valid = new Date(date)
    if valid.toDateString() != 'Invalid Date' and (valid - new Date()) > 0
      # TODO parseInt might not work all the time,might need to look for alternatives
      # BUT theoretically the dates should not have seconds or minuts (0:0:0)
      return parseInt(valid.getTime() / 1000)
    else
      $('.date-input').addClass('invalid')
      return false

  checkName = (name) ->
    if name.length > 0
      return name
    else
      $('.full-name').addClass('invalid')
      return false

  shakeForm = ()->
    $('.form-wrapper').addClass('shake')
    removeShake = ()->
      $('.form-wrapper').removeClass('shake')
    setTimeout(removeShake, 200)

  addLoading = ()->
    $('.form-box').removeClass('loaded')
    setDisplayNone = ()->
      $('.form-wrapper').css('display', 'none')
    setTimeout(setDisplayNone, 400)

  window.submitForm = ->
    $('.invalid').removeClass('invalid')
    date = checkDate($('.date-input').val())
    name = checkName($('.full-name').val())
    insta = $('.instagram').val()
    hexcolor = $('.color-chooser').val()

    if !date or !name
      # TODO add messeage if date is invalid
      shakeForm()
      return

    newPost = {
      'dateend': date,
      'fullname': name,
      'insta': insta,
      'hexcolor': hexcolor
    }

    # this should stop multiple query
    # TODO add message saying its waiting for server or something
    addLoading()

    $.ajax({
      type: 'POST',
      url: 'http://dream-deferred.herokuapp.com/new',
      datatype: 'json',
      contentType: 'application/json',
      data: JSON.stringify(newPost),
      error: ->
        window.location = '/error'
      success: ->
        window.location = '/success'
      })
