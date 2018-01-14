
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show update]
  before_action :load_question, only: %i[update show destroy]
  
  def index
    @questions = Question.all
  end
  
  def show
    @answer = Answer.new
  end
  
  def new
    @question = Question.new
  end
  
  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = 'Your question was successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question was successfully deleted.'
    else
      flash[:notice] = 'You dont have the right to delete this quesitonr'
    end
    redirect_to questions_path
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body)
  end
end
