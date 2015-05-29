module Voted
  extend ActiveSupport::Concern
  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :unvote]
    before_action :authorize_vote, only: [:vote_up, :vote_down]
  end

  def vote_up
    respond_to do |format|
      format.json do
        if @votable.vote(current_user, 1)
          render partial: 'votes/vote'
        else
          render plain: 'vote missed', layout: true
        end
      end
    end
  end

  def vote_down
    respond_to do |format|
      format.json do
        if @votable.vote(current_user, -1)
          render partial: 'votes/vote'
        else
          render plain: 'vote missed', layout: true
        end
      end
    end
  end

  def unvote
    respond_to do |format|
      format.json do
        if @votable.voted_by?(current_user) && @votable.unvote(current_user)
          render partial: 'votes/vote'
        else
          render plain: 'vote missed', layout: true
        end
      end
    end
  end

  private

  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def authorize_vote
    if @votable.user == current_user || @votable.voted_by?(current_user)
      render status: :forbidden, text: 'you cant do it'
    end
  end
end
