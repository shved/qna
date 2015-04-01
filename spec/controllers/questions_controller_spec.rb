require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question)  }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(Question.all)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new, id: question }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        #old_count: Question.count
        #post: create, question: attributes_for(:question)
        #expect(Question.count).to eq old_count + 1
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        #expect(response).to redirect_to question_path(Question.last)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the quesiton' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns the requested question to @question' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, id: question,
        question: { title: '098765432112345', body: '098765432109876543210987654321' }, format: :js
      question.reload #ensure that we just took it from db
      expect(question.title).to eq '098765432112345'
      expect(question.body).to eq '098765432109876543210987654321'
    end

    it 'renders update template' do
      patch :update, id: question, question: attributes_for(:question), format: :js
      expect(response).to render_template :update
    end
  end

  describe 'PATCH #destroy' do
    let(:create_auth_question) { create(:question, user: @user) }

    before do
      @user = user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
      create_auth_question
    end

    it 'deletes question' do
      expect { delete :destroy, id: create_auth_question, user: @user }.to change(Question, :count).by(-1)
    end

    it 'redirects to index view' do
      delete :destroy, id: create_auth_question
      expect(response).to redirect_to questions_path
    end
  end
end
