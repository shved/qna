require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create :user }
    let(:question) { create :question }
    let(:user_question) { create :question, user: user }
    let(:attachment) { create :attachment, attachable: question }
    let(:own_attachment) { create :attachment, attachable: user_question }
    let(:answer_in_user_question) { create :answer, question: user_question }
    let(:answer) { create :answer }
    let(:user_answer) { create :answer, user: user }
    let(:voted_question) { question.vote(user, 1); question }
    let(:voted_answer) { answer.vote(user, 1); answer }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, user_question, user: user }
    it { should_not be_able_to :update, question, user: user }

    it { should be_able_to :update, user_answer, user: user }
    it { should_not be_able_to :update, answer, user: user }

    it { should be_able_to :destroy, user_question, user: user }
    it { should_not be_able_to :destroy, question, user: user }

    it { should be_able_to :destroy, user_answer, user: user }
    it { should_not be_able_to :destroy, answer, user: user }

    it { should be_able_to :destroy, own_attachment, user: user }
    it { should_not be_able_to :destroy, attachment, user: user }

    it { should be_able_to :mark_best, answer_in_user_question, user: user }
    it { should_not be_able_to :mark_best, answer, user: user }

    it { should be_able_to :vote_up, answer, user: user }
    it { should be_able_to :vote_down, answer, user: user }
    it { should be_able_to :unvote, voted_answer, user: user }
    it { should be_able_to :vote_up, question, user: user }
    it { should be_able_to :vote_down, question, user: user }
    it { should be_able_to :unvote, voted_question, user: user }

    it { should_not be_able_to :vote_up, user_answer, user: user }
    it { should_not be_able_to :vote_down, user_answer, user: user }
    it { should_not be_able_to :vote_up, user_question, user: user }
    it { should_not be_able_to :vote_down, user_question, user: user }
  end
end
