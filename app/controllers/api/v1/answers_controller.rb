class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end


  def answer_params
    params.require(:answer).permit(:body)
  end
end