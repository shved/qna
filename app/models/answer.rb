class Answer < ActiveRecord::Base
  default_scope { order(score: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true,
                   length: { in: 30..1000 }
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :score, numericality: { only_integer: true }

  validates_associated :question
  validates_associated :user

  def vote
    new_score = self.score + 1
    self.update(score: new_score)
  end
end
