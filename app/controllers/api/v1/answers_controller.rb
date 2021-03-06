class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  before_action :load_question, only: %i[index create]

  def index
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @answer = Answer.create(answer_params.merge(user: current_resource_owner, question: @question))
    respond_with @answer
  end


  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end