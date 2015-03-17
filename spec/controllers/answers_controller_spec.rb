require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }


  #describe 'GET #index' do
  #  let(:answers) { create_list(:answer, 2, question_id: question) }
  #  before do
  #    get :index, question_id: question
  #  end
  #
  #  it 'populates an array of all question\'s answers' do
  #    expect(assigns(:answers)).to match_array(answers)
  #  end
  #
  #  it 'renders index view' do
  #    expect(response).to render_template :index
  #  end
  #end

  describe 'GET #new' do
    before { get :new, question_id: question}
    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
               .to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }
               .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end
end
