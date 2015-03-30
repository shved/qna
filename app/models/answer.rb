class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true,
                   length: { in: 30..1000 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  validates_associated :question
  validates_associated :user
end
