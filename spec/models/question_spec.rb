require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it do
    should validate_length_of(:title)
      .is_at_least(15)
      .is_at_most(150)
      .with_short_message('Title must be at least %{ count } characters long')
      .with_long_message('Title must be shorter then %{ count } characters')
  end
  it do
    should validate_length_of(:body)
      .is_at_least(30)
      .is_at_most(1000)
      .with_short_message('Question must be at least %{ count } characters long')
      .with_long_message('Question must be shorter then %{ count } characters')
  end

  it { should have_many(:answers).dependent(:destroy) }
end
