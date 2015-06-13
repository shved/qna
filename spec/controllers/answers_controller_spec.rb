require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:other_answer) { create(:answer, question: question) }

  # answer creation response made with pure websocket publishing

  # describe 'POST # create' do
  #   sign_in_user

  #   context 'with valid attributes' do
  #     it 'saves the new answer in the database' do
  #       expect { post :create, question_id: question, answer: attributes_for(:answer), format: :json }
  #              .to change(question.answers, :count).by(1)
  #     end

  #     it 'renders create template' do
  #       post :create, question_id: question, answer: attributes_for(:answer), format: :json
  #       expect(response.header['Content-Type']).to include 'application/json'
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'does not save the answer' do
  #       expect { post :create,
  #                     question_id: question,
  #                     answer: attributes_for(:invalid_answer),
  #                     format: :json }.to_not change(Answer, :count)
  #     end

  #     it 'renders create template' do
  #       post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json
  #       expect(response.header['Content-Type']).to include 'application/json'
  #     end
  #   end
  # end

  #==============================
  describe 'PATCH # update' do
    sign_in_user

    context 'with valid data' do
      let(:update_answer) do
        patch :update, id: answer, question_id: question, answer: { body: 'asdfasdfasdfasdfasdfasdf' }, format: :js
      end

      it 'updates answer attributes' do
        patch(
          :update,
          id: answer,
          question_id: answer.question,
          answer: { body: 'asdfasdfasdfasdfasdfasdf'},
          format: :js
        )
        answer.reload
        expect(answer.body).to eq 'asdfasdfasdfasdfasdfasdf'
      end

      it 'renders answer' do
        expect(update_answer).to render_template('answers/update')
      end
    end

    context 'with invalid data' do
      let(:invalid_answer_update) do
        patch :update, id: answer, question_id: question, answer: attributes_for(:invalid_answer), format: :js
      end

      it 'doesnt update answer' do
        expect { invalid_answer_update }.to_not change { answer.reload.body }
      end
    end
  end

  #==============================
  describe 'PATCH # destroy' do
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
  describe 'PATCH # mark_best' do
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

    it 'changes answers best property' do
      patch :mark_best, id: answer, question_id: question, format: :js
      answer.reload # ensure that we just took it from db

      expect(answer.best).to be true
    end

    it 'renders update template' do
      patch :mark_best, id: answer, question_id: question, format: :js

      expect(response).to render_template :mark_best
    end
  end
end
