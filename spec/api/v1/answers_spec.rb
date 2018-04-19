require 'rails_helper'

describe 'Answers API' do
  describe 'GET /show' do
    context 'unauthorized' do
      let(:user) { @user || create(:user) }
     
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user)}

      it 'returns 401 status if there is no access token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { @user || create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user)}
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment_api, attachable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token }}

      it { expect(response).to be_success }

      %w[body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")}
      end
    end
  end
end
