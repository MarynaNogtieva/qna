module VoteAction
  extend ActiveSupport::Concern

  included do
    before_action :load_item, only: %i[reset_vote vote_for vote_against]
  end

  def vote_for
    if current_user.author_of?(@item) || @item.voted?(current_user)
      flash[:notice] = 'You dont have the right to vote for this question'
    else
      @item.vote_for(current_user)
      render json: { score: @item.vote_score }
    end
  end

  def vote_against
    if current_user.author_of?(@item) || @item.voted?(current_user)
      flash[:notice] = 'You dont have the right to vote against this question'
    else
      @item.vote_against(current_user)
      render json: { score: @item.vote_score }
    end
  end

  def reset_vote
    if current_user.author_of?(@item) || !@item.voted?(current_user)
      flash[:notice] = 'You dont have the right to reset vote for this question'
    else
      @item.reset_vote(current_user)
      render json: { score: @item.vote_score }
    end
  end

  private
  def load_item
    @item = controller_name.classify.constantize.find(params[:id])
  end
end