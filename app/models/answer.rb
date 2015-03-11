class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true,
                   length: { in: 30..1000 }
  validates_associated :question
end
