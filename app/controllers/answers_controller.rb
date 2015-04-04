class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question
  before_action :load_answer, only: [:destroy, :show]

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create answer_params.merge(user: current_user)

    if @answer.errors.empty?
      flash[:notice] = 'Your answer submitted'
    else
      flash[:warning] = 'Oops! Your answer wont save'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      flash[:notice] = 'Your answer deleted'
    end
  end

  private

  def load_question
    @question = Question.find params[:question_id]
  end

  def load_answer
    @answer = Answer.find params[:id]
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
