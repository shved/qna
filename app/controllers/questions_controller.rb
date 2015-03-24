class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :load_question, only: [ :show, :edit, :update, :destroy ]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.create question_params.merge(user: current_user)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:notice] = 'You must fill all fields.'
      render :new
    end
  end

  def update
    @question.update(question_params)

    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path, notice: 'Your question was deleted'
    else
      redirect_to @question
    end
  end

  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
