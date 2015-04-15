require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(30).is_at_most(1000) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }

  it { should accept_nested_attributes_for :attachments }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }
  let!(:answers) { create_list(:answer, 3, question: question, user: user) }

  describe '#mark_best' do
    it "sets all answer's :best to false" do
      answer.mark_best
      answers.each do |a|
        a.reload
        expect(a).to_not be_best
      end
    end

    it "sets @answer's :best to true" do
      answer.mark_best
      answer.reload
      expect(answer).to be_best
    end
  end
end
