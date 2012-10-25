# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ->
  setTimeout (->
    source = new EventSource("/stream")
    source.addEventListener "refresh", (e) ->
      $('.stream').prepend("<p>" + e.data + "</p>")
  ), 1