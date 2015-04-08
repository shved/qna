require 'faker'

FactoryGirl.define do
  factory :answer do
    body Faker::Lorem.characters(30)
    score 0
    best false
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    score 0
    best false
    question
    user
  end
end
