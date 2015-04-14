require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it do
    should validate_length_of(:title).is_at_least(15).is_at_most(150)
  end
  it do
    should validate_length_of(:body).is_at_least(30).is_at_most(1000)
  end

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }
end
