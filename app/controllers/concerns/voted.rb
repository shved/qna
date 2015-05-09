module Voted
  extend ActiveSupport::Concern
  included do
    before_action :load_votable
    before_action :authorize_vote
  end

  def vote_up
    @votable.vote(current_user, 1)
  end

  def vote_down
    @votable.vote(current_user, -1)
  end

  def unvote
    @votable.unvote(current_user) if @votable.voted_by? current_user
  end

  private
    def load_votable
      @votable = controller_name.classify.constantize.find(params[:id])
    end

    def authorize_vote
      if @votable.user == current_user || @votable.voted_by?(current_user)
        render status: :forbidden, text: 'you just cant'
      end
    end
end
