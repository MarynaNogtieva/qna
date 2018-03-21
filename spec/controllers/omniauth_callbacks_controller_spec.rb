require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:facebook)
    end

    context 'new user' do
      before { get :facebook }

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'creates new user' do
        expect(controller.current_user).to_not eq nil
      end
    end

    context 'user already exisits' do
      before do
        auth = mock_auth_hash(:facebook)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :facebook
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq user
      end
    end
  end
end