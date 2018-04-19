require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3, user: user) }
      let(:question) {questions.first}
      let!(:answer) { create(:answer, question: question, user: user)}
      before { get '/api/v1/questions/', params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      it 'returns a list of questions' do
        expect(response.body).to have_json_size(3).at_path('questions')
      end

      %w[id title body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}") }
      end

      it 'questions object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'is included in a question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}") }
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let(:question) { create(:question) }

      it 'returns 401 status if there is no access token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do 
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w[id title body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}") }
      end
      # context 'comments' do
      #   it 'is included in a question object' do
      #     expect(response.body).to have_json_size(1).at_path('questions/0/comments')
      #   end

      #   %w[id body commentable_type commentable_id user_id created_at updated_at].each do |attr|
      #     it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}") }
      #   end
      # end
    end
  end
end
