
class QuestionsController < ApplicationController
  include VoteAction
  
  before_action :authenticate_user!, except: %i[index show update]
  before_action :load_question, only: %i[update show destroy]
  after_action :publish_question, only: %i[create]
  
  def index
    @questions = Question.all
  end
  
  def show
    @answer = Answer.new
    @answer.attachments.build
    gon.is_user_signed_in = user_signed_in?
    gon.question_owner = @question.user_id == (current_user && current_user.id)
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

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', 
      ApplicationController.render(
        partial: 'common/questions_list',
        locals: { question: @question }
      )
    )
  end
  
  def load_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
