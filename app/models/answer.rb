class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, presence: true,
                   length: { in: 30..1000,
                             too_short: "Answer must be at least %{ count } characters long",
                             too_long: "Answer must be shorter then %{ count } characters" }
  validates_associated :question
end
