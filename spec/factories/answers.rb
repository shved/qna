require 'faker'

FactoryGirl.define do
  factory :answer do
    body Faker::Lorem.characters(30)
    score 0
    best false
    question
    user

    trait :with_files do
      after(:create) do |answer|
        create_list(:attachment, 2, attachable: answer)
      end
    end
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    score 0
    best false
    question
    user
  end
end
