class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      format.js do
        if @comment.save
          PrivatePub.publish_to "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }",
                                comment: render(template: 'comments/comment.json.jbuilder')
        else
          render :error
        end
      end
    end
  end

  private

  def load_commentable
    @commentable = commentable_klass.find params["#{commentable_name}_id"]
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable).merge(user_id: current_user.id)
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_klass
    commentable_name.classify.constantize
  end
end
