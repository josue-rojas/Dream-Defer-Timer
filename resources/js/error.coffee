---
---

document.addEventListener "DOMContentLoaded", ->
  if document.referrer in ['http://localhost:4000/submit', 'http://dream-deferred.xyz/submit']
    redi = () ->
      window.location = '/'
    timerText = (seconds) ->
      $('.redirect').text('Redirecting: ' + seconds)
      setTimeout(timerText, 1000, seconds-1)
    setTimeout(redi, 5000)
    timerText(5)
  else
    window.location = '/'
