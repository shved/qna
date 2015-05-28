class CommentsController < ApplicationController
  before_action :authenticate_user!, :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      format.js do
        if @comment.save
          PrivatePub.publish_to "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments",
                                comment: render(template: 'comments/comment.json.jbuilder')
        else
          render :error
        end
      end
    end
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
end
