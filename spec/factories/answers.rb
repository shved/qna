require 'faker'

FactoryGirl.define do
  factory :answer do
    body Faker::Lorem.characters(30)
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
  end
end
