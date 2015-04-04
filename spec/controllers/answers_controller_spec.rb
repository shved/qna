require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question, user: current_user) }
  let(:answer) { create(:answer, question: question, user: current_user) }
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

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: '098765432109876543210987654321' }, format: :js
      answer.reload #ensure that we just took it from db

      expect(answer.body).to eq '098765432109876543210987654321'
    end

    it 'renders update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js

      expect(response).to render_template :update
    end
  end

  describe 'PATCH #destroy' do
    sign_in_user

    before do
      answer
      other_answer
    end

    context 'own answer' do
      it 'deletes answer' do
        expect {
          delete :destroy, id: answer, question_id: question, format: :js
        }.to change(Answer, :count).by(-1)
      end

      it 'redirects to answer question path' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'other answer' do
      it 'dont delete answer' do
        expect {
          delete :destroy, id: anothers_answer, question_id: question
        }.to_not change(Answer, :count)
      end
    end

    # it 'deletes answer' do
    #   expect { delete :destroy, id: answer, question_id: question }
    #          .to change(Answer, :count).by(-1)
    # end

    # it 'redirects to question view' do
    #   delete :destroy, id: answer, question_id: question
    #   expect(response).to redirect_to question_path(question)
    # end
  end
end
