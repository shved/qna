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
    params.each do |param_name, value|
      @commentable = param_name[0..-3].classify.constantize.find(value) if /(.+)_id$/.match(param_name)
    end
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user_id: current_user.id)
  end

  def publish_comment
    PrivatePub.publish_to "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments",
                          comment: render_to_string(template: 'comments/comment.json.jbuilder')
  end
end
