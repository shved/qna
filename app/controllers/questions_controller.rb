class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :edit, :update, :destroy ]

  include Voted

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with @question
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))

    if @question.errors.empty?
      PrivatePub.publish_to '/questions', question: @question.to_json
    end
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    if @question.user == current_user
      respond_with(@question.destroy)
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
