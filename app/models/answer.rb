class Answer < ActiveRecord::Base
  default_scope { order(best: :desc, score: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true,
                   length: { in: 30..1000 }
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :score, numericality: { only_integer: true }
  validates :best, inclusion: { in: [true, false] }

  validates_associated :question
  validates_associated :user

  def mark_best
    self.question.answers.update_all(best: false)
    self.update(best: true)
  end

  def vote
    self.increment!(:score)
  end
end
