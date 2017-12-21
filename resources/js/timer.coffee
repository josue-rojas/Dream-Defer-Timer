---
---

# TODO check if valid id  in json
id = window.location.hash.match(/\d+/)[0]
if !id
  window.location = '/'

convertepoch = (epoch) ->
  return new Date(epoch*1000)

add = (a, b)->
  return a + b

document.addEventListener "DOMContentLoaded", ->
  newTime = (date)->
    total = (date - new Date()) * .001
    if total < 0
      # Expired should be displayed (or redirected, still havent decided)
      return false
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

  $.getJSON('/resources/2d341dui2udibe.json', (data)->
    date = convertepoch(data[id].dateend)
    # hexcolor = data[id].hexcolor
    instaUser = data[id].insta
    $('.title').text(data[id].fullname + "'s Expiration")
    if instaUser
      instagram = '<a class="insta-large" href="https://www.instagram.com/'  + instaUser + '"></a>'
      $('.instagram').html(instagram)

    newTime(date)
    $('.timer').addClass('loaded')

    )
