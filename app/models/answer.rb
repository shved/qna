class Answer < ActiveRecord::Base
  default_scope { order(best: :desc, score: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true,
                   length: { in: 30..1000 }
  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :score, numericality: { only_integer: true }
  validates :best, inclusion: { in: [true, false] }

  validates_associated :question
  validates_associated :user

  accepts_nested_attributes_for :attachments, reject_if: lambda { |a| a[:file].blank? }, allow_destroy: true

  def mark_best
    Answer.transaction do
      Answer.where(question: question_id, best: true).update_all(best: false)
      update(best: true)
    end
  end

  def vote
    increment!(:score)
  end
end
