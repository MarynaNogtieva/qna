require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 403 status if there is no access token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 403
      end

      it 'returns 403 status if access token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 403
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      %w(id email created_at updated_at admin).each do |attr|
        it { expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr) }
      end

      %w(password encrypted_password).each do |attr|
        it { expect(response.body).to_not have_json_path(attr) }
      end

    end
  end


  describe 'GET /profiles' do
    it_behaves_like 'API Authenticable'
    
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:others) { create_list(:user, 2) }

      before { get '/api/v1/profiles/', params: { format: :json, access_token: access_token.token } }

      it { expect(response).to be_success }

      it 'should not show the info about curent user' do
        expect(response.body).not_to include_json(me.to_json)
      end

      it 'should show info about users list' do
        expect(response.body).to be_json_eql(others.to_json).at_path('profiles')
      end

      %w(id email created_at updated_at admin).each do |attr|
        it { expect(response.body).to be_json_eql(others.first.send(attr.to_sym).to_json).at_path("profiles/0/#{attr}") }
      end

      %w(password encrypted_password).each do |attr|
        it { expect(response.body).to_not have_json_path(attr) }
      end

    end

    def do_request(options = {})
      get '/api/v1/profiles/', params: { format: :json }.merge(options)
    end
  end
end