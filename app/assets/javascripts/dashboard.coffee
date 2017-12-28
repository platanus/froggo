# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
document.addEventListener 'DOMContentLoaded', (->
  melements = document.getElementsByClassName('td__span')
  i = 0
  while i < melements.length
    if melements[i].innerHTML.replace(/\s/g,'') == "0"
      melements[i].className= 'td__span-0';
    i++
  return
), false