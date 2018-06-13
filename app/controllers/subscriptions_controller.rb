class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_subscribtion, only: [:destroy]

  respond_to :json, :js

  authorize_resource

  def create
    @subscription = current_user.add_subscription(@question)
    respond_with(@subscription, template: 'common/subscribe')
  end

  def destroy
    @question = @subscription.question
    respond_with(@subscription.destroy!, template: 'common/subscribe')
  end

  private

  def load_subscribtion
    @subscription = Subscription.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end