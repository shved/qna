# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
showCreateCommentForm = (e) ->
  e.preventDefault()
  $(this).parent().parent().find('.comment-create-form').show()
  $(this).hide()

$(document).ready ->
  $(document).on('click', '.comment-create-link', showCreateCommentForm)
