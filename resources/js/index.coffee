---
---

convertepoch = (epoch) ->
  return new Date(epoch*1000)

add = (a, b)->
  return a + b

# unix epoch
document.addEventListener "DOMContentLoaded", ->
  current = 0
  max = 0
  all = ''
  first = true
  newTime = (date)->
    total = (date - new Date()) * .001
    if total < 0
      # TODO should display a message here
      if ++current >= max
        $('.next').removeClass('loaded')
        return false
      return setTimeout(newTime, 1000, convertepoch(all[current].dateend))
    days = Math.trunc(total / 86400)
    total = total - (days*86400)
    hours = Math.trunc(total / 3600)
    total = total - (hours * 3600)
    minutes = Math.trunc(total / 60)
    seconds = Math.trunc(total - (minutes * 60))
    $('.days').text(days + ' Days')
    $('.hours').text(hours + ' Hours')
    $('.minutes').text(minutes + ' Minutes')
    $('.seconds').text(seconds + ' Seconds')
    setTimeout(newTime, 1000, date)
    if first
      $('.next').addClass('loaded')
      first = false
    # return true

  # TODO need to check if data == 0
  $.getJSON('/resources/2309ru88uyf384.json', (data)->
    all = data
    max = data.length
    # TODO check if length > current might cause error if there is none
    date = convertepoch(data[current].dateend)
    newTime(date)
    # $('.next').addClass('loaded')
    )
