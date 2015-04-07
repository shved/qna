require 'faker'

FactoryGirl.define do
  factory :answer do
    body Faker::Lorem.characters(30)
    score 0
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    score 0
    question
    user
  end
end
