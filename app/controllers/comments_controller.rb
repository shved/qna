class CommentsController < ApplicationController
  before_action :authenticate_user!, :load_commentable
  after_action :publish_comment, only: :create

  respond_to :js

  def create
    @comment = Comment.create(comment_params.merge(commentable: @commentable))
    respond_with(@comment)
  end

  private

  def load_commentable
    @commentable = commentable_klass.find params["#{ commentable_name }_id"]
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_klass
    commentable_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end

  def publish_comment
    PrivatePub.publish_to "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments",
                          comment: render_to_string(template: 'comments/comment.json.jbuilder')
  end
end
