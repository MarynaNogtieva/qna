class AnswersController < ApplicationController
  include VoteAction
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update best_answer ]
  after_action :publish_answer, only: %i[create]

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
      flash.now[:notice] = 'Only an author of the answer can delete it'
      render 'common/messages'
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def best_answer 
    if current_user.author_of?(@answer.question)
      @answer.mark_best
    end
    @question = @answer.question
  end

  private
  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |attach|
      { id: attach.id, filename: attach.file.filename, url: attach.file.url }
    end

    data = {
      answer: @answer,
      id: @answer.id,
      body: @answer.body,
      question_id: @answer.question_id,
      user_id: @answer.user_id,
      created_at: @answer.created_at,
      update_at: @answer.updated_at,
      best: @answer.best,
      attachments: attachments
    }

    ActionCable.server.broadcast("questions_#{@question.id}", 
      data: data
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end