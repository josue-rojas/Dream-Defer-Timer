---
---
# nav
document.addEventListener "DOMContentLoaded", ->
  window.navbarShow = () ->
    $menu = $('.default-nav')
    if $menu.hasClass('active')
      $menu.removeClass('active')
    else
      $menu.addClass('active')
