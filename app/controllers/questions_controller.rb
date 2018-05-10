
class QuestionsController < ApplicationController
  include VoteAction

  respond_to :html, :json, :js
  
  before_action :authenticate_user!, except: %i[index show update]
  before_action :load_question, only: %i[update show destroy subscribe]
  before_action :build_answer, only: %i[show]
  after_action :publish_question, only: %i[create]

  # load corresponding object, here we do not need load question  -  load_and_authorize_resource
  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end
  
  def show
    gon.is_user_signed_in = user_signed_in?
    gon.question_owner = @question.user_id == (current_user && current_user.id)
    respond_with @question
  end
  
  def new
    @question = Question.new
    respond_with (@question.attachments.build)
  end
  
  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  def subscribe
    @subscription = @question.add_subscription(current_user)
    # respond_with(@question.add_subscription(current_user), location: @question)
  end
  
  private
  
  def build_answer
    @answer = Answer.new
    @answer.attachments.build
  end

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
