# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
showCreateCommentForm = (e) ->
  e.preventDefault()
  $(this).parent().parent().find('.comment-create-form').show()
  $(this).hide()

$(document).ready ->
  $(document).on('click', '.comment-create-link', showCreateCommentForm)

  questionId = $('.answers').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentableIdSelector = comment.commentable + '-' + comment.commentable_id
    console.log(commentableIdSelector)
    console.log('#' + commentableIdSelector + ' > .comments-for-' + commentableIdSelector)
    content = JST['templates/comment']({ comment: comment })
    $('#' + commentableIdSelector + ' > #comments-for-' + commentableIdSelector).append(content)
    $('#' + commentableIdSelector + ' > .comment-create-form').hide()
    $('#' + commentableIdSelector + ' > .comment-create-link').show()
