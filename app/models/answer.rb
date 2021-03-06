class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :comments, dependent: :destroy, as: :commentable

  include Votable

  default_scope { order(best: :desc, created_at: :asc) }

  validates :body, presence: true,
                   length: { in: 15..1000 }
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
end
