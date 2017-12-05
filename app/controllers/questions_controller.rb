class QuestionsController < ApplicationController
  before_action :load_question, only: [ :edit, :show ]
  
  def index
    @questions = Question.all
  end
  
  def show; end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = Question.new(question_params)
    @question.save
    redirect_to @question
    # if @question.save
    #   redirect_to @question
    # else
    #   render :new
    # end
  end
  
  def edit; end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require[:question].permit(:title, :body)
  end
end
