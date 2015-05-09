# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $("#edit-answer-#{ answer_id }").show()

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    console.log(xhr.responseText)
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append("<div class='answer-" + answer.id + "'><p>" + answer.body + "</p></div>")
    $('textarea#answer_body').val('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    id = $(this).attr('id').substr(-2, 2)
    $(this).hide()
    $('#answer-' + id + ' > p.answer_body').text(answer.body)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)
