module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    vote = votes.find_or_create_by(user: user, value: value)
  end

  def unvote(user)
    votes.where(user: user).delete_all
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end

  def score
    votes.sum :value
  end
end
