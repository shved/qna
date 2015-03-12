class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true,
                    length: { in: 15..150,
                              too_short: "Title must be at least %{ count } characters long",
                              too_long: "Title must be shorter then %{ count } characters" }
  validates :body, presence: true,
                   length: { in: 30..1000,
                             too_short: "Question must be at least %{ count } characters long",
                             too_long: "Question must be shorter then %{ count } characters" }
end
