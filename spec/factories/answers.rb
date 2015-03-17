FactoryGirl.define do
  factory :answer do
    body "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
  end
end
