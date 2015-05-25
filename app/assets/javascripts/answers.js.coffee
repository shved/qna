# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
editAnswer = (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  $("#edit-answer-#{ answer_id }").show()

editAnswerSuccess = (e, data, status, xhr) ->
  answer = $.parseJSON(xhr.responseText)
  $(this).hide()
  $('#answer-' + answer.id).replaceWith(JST['templates/answer']({ answer: answer }))

editAnswerError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  id = $(this).attr('data-id')
  $.each errors, (index, value) ->
    $('#answer-' + id + ' > .answer-errors').append(value)

# createAnswerSuccess = (e, data, status, xhr) ->
#   answer = $.parseJSON(xhr.responseText)
#   $('.answers').append(JST['templates/answer']({ answer: answer }))
#   $('textarea#answer_body').val('')

# createAnswerError = (e, data, status, xhr) ->
#   errors = $.parseJSON(xhr.responseText)
#   $.each errors, (index, value) ->
#     $('.answer-errors').append(value)

vote = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $("#answer-#{ votable.votable_id } > .vote-box").replaceWith(JST['templates/vote']({ votable: votable }))

voteError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $("#answer-#{ votable.votable_id } > .vote-errors").append(value)

$(document).ready ->

  $(document).on('click', '.edit-answer-link', editAnswer)
  # $(document).on('ajax:success', 'form.new_answer', createAnswerSuccess)
  # $(document).on('ajax:error', 'form.new_answer', createAnswerError)
  $(document).on('ajax:success', 'form.edit_answer', editAnswerSuccess)
  $(document).on('ajax:error', 'form.edit_answer', editAnswerError)
  $(document).on('ajax:success', '.answers .vote-box', vote)
  $(document).on('ajax:error', '.answers .vote-box', voteError)

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId, (data, channel) ->
    answer = $.parseJSON(data['answer'])
    $('.answers').append(JST['templates/answer']({ answer: answer }))
