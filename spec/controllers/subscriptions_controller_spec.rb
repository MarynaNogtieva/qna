require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) {  create(:user) }
  let!(:subscriber) { @user || create(:user) }
  let!(:question) { create(:question, user: user) }
  
  describe 'POST #create' do
    let(:create_subscription) { post :create, params: { question_id: question.id, user_id: subscriber.id, format: :js } }
    sign_in_user


    it 'assigns question to @question' do
       create_subscription
       expect(assigns(:subscription).question).to eq question
    end

    it 'saves the new subscription to database' do
      expect{ post :create, params: { question_id: question.id, user_id: subscriber.id, format: :js } }.to change(Subscription, :count).by(1)
    end

    it 'render create view' do
      create_subscription
      expect(response).to render_template "common/subscribe"
    end
  end

  # describe 'DELETE #destroy' do

  #   before { subscriber = sign_in_user }
  #   let!(:subscription) { create(:subscription, question: question, user: subscriber) }

  #     it 'deletes subscription' do
  #       expect { delete :destroy, params:  { question_id: question.id, user_id: subscriber.id, id: subscription }, format: :js  }.to change(Subscription, :count).by(-1)
  #     end

  #     it 'assigns subscription to @subscription' do
  #       expect(assigns("subscription")).to eq @subscription
  #     end

  #     it 'render destroy view' do
  #       delete :destroy, params:  { question_id: question.id, user_id: subscriber.id, id: subscription }, format: :js
  #       expect(response).to render_template "common/subscribe"
  #    end
  # end
end