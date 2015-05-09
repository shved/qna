class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question
  before_action :load_answer, only: [:destroy, :show, :mark_best, :update]

  include Voted

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build answer_params.merge(user: current_user)

    respond_to do |format|
      if @answer.save
        format.html { render partial: 'questions/answers', layout: false }
        format.json { render json: @answer }
        flash.now[:notice] = 'Your answer submitted'
      else
        format.html { render text: @answer.errors.full_messages.join(', '), status: :unprocessable_entity }
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params)

    respond_to do |format|
      if @answer.errors.empty?
        format.json { render json: @answer }
        flash.now[:notice] = 'Answer updated'
      else
        format.json {render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if owns_answer?
      @answer.destroy
      flash[:notice] = 'Your answer deleted'
    end
  end

  def mark_best
    if owns_question?
      @answer.mark_best
      flash[:notice] = 'Successfully accepted answer'
    end
  end

  private
    def owns_answer?
      return true if @answer.user == current_user
    end

    def owns_question?
      return true if @question.user == current_user
    end

    def load_question
      @question = Question.find params[:question_id]
    end

    def load_answer
      @answer = Answer.find params[:id]
    end

    def answer_params
      params.require(:answer).permit(:body, :question_id, attachments_attributes: [:id, :file, :_destroy])
    end
end
