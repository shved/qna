require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_inclusion_of(:votable_type).in_array ['Question', 'Answer'] }
  it { should validate_inclusion_of(:value).in_array [-1, 1] }

  it { should belong_to :user }
  it { should belong_to :votable }

  let(:users) { create_list(:user, 2) }
  let(:user) { users.at(0) }
  let(:other_user) { users.at(1) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  [:question, :answer].each do |votable_name|
    before { @votable = send votable_name }

    describe "vote for #{ votable_name }" do
      it "voted up by user" do
        expect { @votable.vote user, 1 }.to change(@votable.votes, :count).by(1)
        expect( @votable.voted_by? user ).to be true
      end

      it "voted down by user" do
        expect { @votable.vote user, -1 }.to change(@votable.votes, :count).by(1)
        expect( @votable.voted_by? user ).to be true
      end

      it "only one vote is accepted from user for any given #{ votable_name }" do
        @votable.vote user, 1
        expect { @votable.vote user, 1 }.to_not change(@votable.votes, :count)
        expect { @votable.vote user, -1 }.to_not change(@votable.votes, :count)
      end

      it "change vote" do
        @votable.vote user, 1
        @votable.unvote user
        expect( @votable.voted_by? user ).to be false
        expect { @votable.vote user, -1 }.to change(@votable.votes, :count).by(1)
        expect( @votable.voted_by? user ).to be true
      end
    end

    describe "#{ votable_name } score" do
      it "#{ votable_name } screo is 0 by default" do
        expect( @votable.score ).to eq 0
      end

      it "voted up by user increments #{ votable_name } score" do
        expect { @votable.vote user, 1 }.to change(@votable, :score).by(1)
      end

      it 'likes by different users increments question score' do
        @votable.vote user, 1
        expect { @votable.vote other_user, 1 }.to change(@votable, :score).by(1)
      end

      it "subsequent votes by same user do not change #{ votable_name } score" do
        @votable.vote user, 1
        expect { @votable.vote user, -1 }.to_not change(@votable, :score)
      end

      it "#{ votable_name } score is changed when user unvotes" do
        @votable.vote user, 1
        expect { @votable.unvote user }.to change(@votable, :score).by(-1)
      end

      it "#{ votable_name } score is changing when the user changes his vote" do
        @votable.vote user, 1
        @votable.unvote user
        expect { @votable.vote user, -1 }.to change(@votable, :score).by(-1)
      end
    end
  end
end
