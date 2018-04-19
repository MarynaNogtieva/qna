class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end