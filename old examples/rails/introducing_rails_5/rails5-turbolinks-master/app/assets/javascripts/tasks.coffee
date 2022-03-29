$(document).on 'click', "[data-behaviour='completed']", ->
  $(this).parent('form').submit()

document.addEventListener "turbolinks:load", ->
  console.log('loaded')

