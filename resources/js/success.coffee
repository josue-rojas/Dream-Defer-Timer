---
---

document.addEventListener "DOMContentLoaded", ->
  if document.referrer in ['http://localhost:4000/submit', 'http://dream-deferred.xyz/submit']
    redi = () ->
      window.location = '/list'
    timerText = (seconds) ->
      $('.redirect').text('Redirecting: ' + seconds)
      setTimeout(timerText, 1000, seconds-1)
    setTimeout(redi, 10000)
    timerText(10)
  else
    window.location = '/'
