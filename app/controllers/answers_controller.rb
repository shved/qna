class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_question
  before_action :load_answer, only: :destroy

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create answer_params.merge(user: current_user)

    if @answer.save
      redirect_to question_path(@question)
      flash[:notice] = 'Your answer submitted'
    else
      render :new
      flash[:warning] = 'Oops! Your answer missed'
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      redirect_to @question
      flash[:notice] = 'Your answer deleted'
    else
      redirect_to @question
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
