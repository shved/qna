# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  editQuestion = (e) ->
    e.preventDefault()
    $(this).hide()
    $("#edit-question").show()

  voteQuestion = (e, data, status, xhr) ->
    votable = $.parseJSON(xhr.responseText)
    $(".question-box > .vote-box").replaceWith(JST['templates/vote']({ votable: votable }))

  voteQuestionError = (e, data, status, xhr) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $(".question-box > .vote-errors").append(value)

  $(document).on('click', '.edit-question-link', editQuestion)
  $(document).on('ajax:success', '.question-box .vote-box', voteQuestion)
  $(document).on('ajax:error', '.qustion-box .vote-box', voteQuestionError)

