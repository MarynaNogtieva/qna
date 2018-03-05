
class CommentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show update]
  before_action :set_commentable, only: %i[create]

  def create
    comment = @commentable.comments.new(comment_params)
    comment.user = current_user
    if comment.save
      render json: { body: comment.body, user: comment.user.email, date: comment.updated_at }
    else
      render json: comment.errors.full_messages
    end
  end

  private

  def set_commentable
    @commentable = Question.find(params[:question_id]) if (params[:question_id]).present?
    @commentable = Answer.find(params[:answer_id]) if (params[:answer_id]).present?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
