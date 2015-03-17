require 'faker'

FactoryGirl.define do
  factory :question do
    title Faker::Lorem.characters(15)
    body Faker::Lorem.characters(30)
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
