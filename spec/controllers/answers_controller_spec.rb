require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
               .to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template 'create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }
               .to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template 'create'
      end
    end
  end

  #==============================
  describe 'PATCH #update' do
    sign_in_user

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question,
        answer: { body: '098765432109876543210987654321' }, format: :js
      answer.reload #ensure that we just took it from db

      expect(answer.body).to eq '098765432109876543210987654321'
    end

    it 'renders update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

      expect(response).to render_template :update
    end
  end

  #==============================
  describe 'PATCH #destroy' do
    sign_in_user

    before do
      answer
      other_answer
      @user.answers << answer
    end

    context 'own answer' do
      it 'deletes answer' do
        expect { delete :destroy, question_id: answer.question, id: answer, format: :js }
          .to change(Answer, :count).by(-1)
      end

      it 'redirects to answer question path' do
        delete :destroy, question_id: answer.question, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'other answer' do
      it 'dont delete answer' do
        expect { delete :destroy, question_id: question, id: other_answer, format: :js }
          .to_not change(Answer, :count)
      end
    end
  end

  #==============================
  describe 'PATCH #vote' do
    before { answer }

    it 'assigns the requested answer to @answer' do
      patch :vote, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

      expect(assigns(:answer)).to eq answer
    end

    it "increments the answer's score" do
      patch :vote, id: answer, question_id: question, answer: { score: 1 }, format: :js
      answer.reload #ensure that we just took it from db

      expect(answer.score).to eq 1
    end

    it 'renders update template' do
      patch :vote, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

      expect(response).to render_template :vote
    end
  end

  #==============================
  describe 'PATCH #mark_best' do
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
      question
      question.user_id = @user.id
      question.save
      answer
    end

    it 'assigns the requested answer to @answer' do
      patch :mark_best, id: answer, question_id: question, format: :js

      expect(assigns(:answer)).to eq answer
    end

    it "changes answers best property" do
      patch :mark_best, id: answer, question_id: question, format: :js
      answer.reload #ensure that we just took it from db

      expect(answer.best).to be true
    end

    it 'renders update template' do
      patch :mark_best, id: answer, question_id: question, format: :js

      expect(response).to render_template :mark_best
    end
  end
end
