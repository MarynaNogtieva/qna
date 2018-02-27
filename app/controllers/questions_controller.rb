
class QuestionsController < ApplicationController
  include VoteAction
  before_action :authenticate_user!, except: %i[index show update]
  before_action :load_question, only: %i[update show destroy]
  
  def index
    @questions = Question.all
  end
  
  def show
    @answer = Answer.new
    @answer.attachments.build
  end
  
  def new
    @question = Question.new
    @question.attachments.build
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
      flash[:notice] = 'You dont have the right to delete this quesiton'
    end
    redirect_to questions_path
  end
  
  private
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
