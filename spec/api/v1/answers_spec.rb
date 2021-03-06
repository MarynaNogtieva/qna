require 'rails_helper'

describe 'Answers API' do
  let!(:user) { @user || create(:user) }
  let!(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }
  let(:answer) { answers.first }
  let!(:comment) { create(:comment, commentable: answer, user: user) }
  let!(:attachment) { create(:attachment_api, attachable: answer) }

  describe 'GET /show' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token }}

      it { expect(response).to be_success }

      %w[body created_at updated_at].each do |attr|
        it { expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")}
      end

      context 'comments' do
        it { expect(response.body).to have_json_size(1).at_path("answer/comments") }
        %w(id body created_at).each do |attr|
          it { expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}") }
        end
      end
      context 'attachments' do
        it { expect(response.body).to have_json_size(1).at_path("answer/attachments") }
        
        %w[url].each do |attr|
          it "answers attachment object contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }
      it { expect(response.body).to have_json_size(2).at_path('answers') }

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like 'API Authenticable'

    context 'authorized' do 
      before { post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json, access_token: access_token.token, answer: attributes_for(:answer) } }

      it { expect(response).to be_success }
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json, action: :create }.merge(options)
    end

  end
end
