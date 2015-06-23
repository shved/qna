class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question
  before_action :load_answer, only: [:destroy, :show, :mark_best, :update]
  after_action :publish_answer, only: :create

  include Voted

  respond_to :js, only: [:create, :update, :destroy, :mark_best]

  authorize_resource

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    if owns_answer?
      @answer.update(answer_params)
    end
    respond_with @answer
  end

  def destroy
    if owns_answer?
      respond_with(@answer.destroy)
    end
  end

  def mark_best
    if owns_question?
      flash[:notice] = 'Successfully accepted answer'
      @answer.mark_best
      respond_with(@answer)
    end
  end

  private

  def owns_answer?
    return true if @answer.user_id == current_user.id
  end

  def owns_question?
    return true if @question.user_id == current_user.id
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

  def publish_answer
    return unless @answer.valid?
    PrivatePub.publish_to "/questions/#{ @question.id }/answers",
                          answer: render_to_string(template: 'answers/_answer.json.jbuilder')
  end
end
