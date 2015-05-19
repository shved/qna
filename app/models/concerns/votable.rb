module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote(user, value)
    votes.find_or_create_by(user: user, value: value)
  end

  def unvote(user)
    votes.where(user: user).delete_all
  end

  def voted_by?(user)
    votes.where(user: user).exists?
  end

  def votable_for?(user)
    true unless user_id == user.id
  end

  def score
    votes.sum :value
  end
end
