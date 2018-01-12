class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create, :destroy ]
  before_action :load_answer, only: [ :destroy, :update ]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      flash[:notice] = 'Your was created successfully'
    else
      render 'errors', notice: 'Something is wrong'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    else
      flash[:notice] = 'You dont have a right to delete this answer'
    end
    redirect_to question_path(@question)
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end
  # new action, check if author of question, new method in answer
  # uncheck from previos best answer, check new
  # use transaction, use !
  #question return current best answer

  private
  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
