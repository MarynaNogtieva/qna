class AnswersController < ApplicationController
  
  include VoteAction
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update best_answer ]
  after_action :publish_answer, only: %i[create]

  respond_to  :js

  def create
    @answer = current_user.answers.new(answer_params.merge(question_id: @question.id))
    respond_with(@answer.save)
  end

  def destroy
    respond_with(@answer.destroy)  if current_user.author_of?(@answer)
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def best_answer 
    @answer.mark_best if current_user.author_of?(@answer.question)
  end

  private
  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |attach|
      { id: attach.id, filename: attach.file.filename, url: attach.file.url }
    end
    data = @answer.as_json(include: :attachments).merge(answer: @answer, 
                                                        voted: @answer.voted?(current_user), 
                                                        vote_score: @answer.vote_score)


    ActionCable.server.broadcast("questions_#{@question.id}", 
      data: data
    )
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end