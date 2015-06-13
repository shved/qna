class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question
  before_action :load_answer, only: [:destroy, :show, :mark_best, :update]

  include Voted

  respond_to :js, only: [:create, :update]

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

    respond_with @answer do |format|
      format.js do
        if @answer.valid?
          PrivatePub.publish_to "/questions/#{ @question.id }/answers",
                                answer: render('answers/_answer.json.jbuilder')
        else
          render 'answers/error'
        end
      end
    end
  end

  def update
    if owns_answer?
      @answer.update(answer_params)
    end
    respond_with @answer
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
