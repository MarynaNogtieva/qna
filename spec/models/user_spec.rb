require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy)}
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:not_author_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    
    context 'user is an author of the question' do
      it 'returns true' do
        expect(user).to be_author_of(question)
      end
    end

    context 'user is not an author of the question' do
      it 'returns false' do
        expect(not_author_user).to_not be_author_of(question)
      end
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '12345')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user does not have authorization' do
      context 'user already exists in db' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: user.email }) }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)                                         
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345', info: { email: 'test@example.com' }) }

      it 'creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end
      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end
      it 'fills user email' do
        user = User.find_for_oauth(auth)

        expect(user.email).to eq auth.info.email
      end
      it 'creates authorization for new user' do
        user = User.find_for_oauth(auth)

        expect(user.authorizations).to_not be_empty
      end
      it 'creates authorization with correct provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 5) }

    it 'should send daily digest to all users' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user).and_call_original
      end

      User.send_daily_digest
    end
  end
end