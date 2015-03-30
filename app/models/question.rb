class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { in: 15..150 }
  validates :body, presence: true, length: { in: 30..1000 }
  validates :user_id, presence: true

  validates_associated :user
end
