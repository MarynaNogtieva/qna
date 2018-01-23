class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [ :create, :destroy, :best_answer]
  before_action :load_answer, only: [ :destroy, :update, :best_answer ]

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
    else
      respond_to do |format|
        format.html { render nothing: true, notice: 'Only an author of the answer can delete it' }
        # render layout: false
      end
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def best_answer 
    @answer = @question.answers.find(params[:id])
    if current_user.author_of?(@question)
      @answer.mark_best
    end
  end

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