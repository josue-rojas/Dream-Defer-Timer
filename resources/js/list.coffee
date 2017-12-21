---
---

# TODO add ability to view all #all
# get digits from hash this will be the max of timers to show
maxShow = window.location.hash.match(/\d+/)
# if no digits then return default
maxShow = if maxShow then parseInt(maxShow[0]) else 30

convertepoch = (epoch) ->
  return new Date(epoch*1000)

add = (a, b)->
  return a + b

checkValidDate = (date) ->
  return ((date - new Date()) * .001) > 0

# https://stackoverflow.com/questions/21646738/convert-hex-to-rgba
getBackgroundColor = (hex) ->
    c
    if /^#([A-Fa-f0-9]{3}){1,2}$/.test(hex)
        c= hex.substring(1).split('');
        if c.length== 3
            c= [c[0], c[0], c[1], c[1], c[2], c[2]];
        c= '0x'+c.join('');
        return 'rgba('+[(c>>16)&255, (c>>8)&255, c&255].join(',')+',.1)';
    # TODO throw should return default value
    throw new Error('Bad Hex');

# function to create a list-item
newListItem = (id, insta, hexcolor) ->
  backColor = ' style="background-color:' + getBackgroundColor('#'+hexcolor) + ';"'
  instagram = if insta.length > 0 then "<a class='insta' href='https://www.instagram.com/" + insta + "'></a>" else ''
  return "<div onclick='timerPage("+ id + ")'class='list-item' id=" + id + backColor + " >
  <div class='days'></div>
  <div class='hours'></div>
  <div class='minutes'></div>
  <div class='seconds'></div>" +
  instagram +  "</div>"

# this function creates a list-row with the proper closing
newListRow = (listItems) ->
  curr = 0
  html = ''
  for item in listItems
    if curr % 4 == 0
      html+= "<div class='list-row'>"
    html+=item
    if curr > 0 and curr % 3 == 0
      html+= "</div>"
    curr++
  if listItems.length % 4 != 0
    html+= "</div>"
  return html


window.timerPage = (id) ->
  window.location = '/timer#' + id

document.addEventListener "DOMContentLoaded", ->
  $dates = []
  realDates = []
  first = true

  changeTimer = (targetIndex) ->
    date = realDates[targetIndex]
    $target = $($dates[targetIndex])
    total = (date - new Date()) * .001
    if total < 0
      # removal might need checking (might need to remove from arrays, but might cause trouble)
      $target.remove()
      return
    days = Math.trunc(total / 86400)
    total = total - (days*86400)
    hours = Math.trunc(total / 3600)
    total = total - (hours * 3600)
    minutes = Math.trunc(total / 60)
    seconds = Math.trunc(total - (minutes * 60))
    $target.find('.days').text(days + ' Days')
    $target.find('.hours').text(hours + ' Hours')
    $target.find('.minutes').text(minutes + ' Minutes')
    $target.find('.seconds').text(seconds + ' Seconds')
    setTimeout(changeTimer, 1000, targetIndex)

    # setup needed for when the html has been added
    if first && $target.length > 0
      $('.boxy-wrapper').addClass('loaded')
      $('.insta').click (e) ->
        e.stopPropagation()
      first = false

  # TODO need to check if data == 0
  $.getJSON('/resources/2309ru88uyf384.json', (data)->

    targetIndex = 0
    current = 0
    listItems = []
    for date in data
      listDate = convertepoch(data[current].dateend)
      # before adding check if list is valid
      # TODO if maxShow is reached then exit (<- add that)
      if checkValidDate(listDate) and targetIndex < maxShow
        listItems.push(newListItem(data[current].id, data[current].insta,  data[current].hexcolor))
        $dates.push('#' + data[current].id)
        realDates.push(listDate)
        changeTimer(targetIndex++)
      current++

    # add all list-items in a row then add to boxu
    $('.boxy').html(newListRow(listItems))

  )
