module Voted
  extend ActiveSupport::Concern
  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :unvote]
    before_action :authorize_vote, only: [:vote_up, :vote_down]
    respond_to :json, only: [:vote_up, :vote_down, :unvote]
  end

  def vote_up
    respond_with(@votable.vote(current_user, 1), template: 'votes/_vote.json.jbuilder')
  end

  def vote_down
    respond_with(@votable.vote(current_user, -1), template: 'votes/_vote.json.jbuilder')
  end

  def unvote
    respond_with(@votable.unvote(current_user), template: 'votes/_vote.json.jbuilder')
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
