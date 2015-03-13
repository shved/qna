require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:answers) { create_list(:answer, 2, question: question) }

  describe 'GET #index' do
    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested answer to @answer' do

    end

    it 'renders show view' do

    end
  end

  describe 'GET #new' do
    it 'assigns a new Answer to @answer' do

    end

    it 'renders new view' do

    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do

      end

      it 'redirects to show view' do

      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do

      end

      it 're-renders new view' do

      end
    end
  end
end
