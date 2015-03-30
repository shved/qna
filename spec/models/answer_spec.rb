require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it do
    should validate_length_of(:body).is_at_least(30).is_at_most(1000)
  end

  it { should belong_to :question }
  it { should belong_to :user }
end
