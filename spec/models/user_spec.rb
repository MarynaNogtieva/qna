require 'rails_helper'

RSpec.describe User, type: :model do 
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy)}
  it { should have_many(:answers) }

  describe '#author_of?' do
    let (:user) { create(:user) }
    let (:not_author_user) { create(:user) }
    let (:question) { create(:question, user: user) }
    
    context 'user is an author of the question' do
      it 'returns true' do
        expect(user.author_of?(question)).to be true
      end
    end

    context 'user is not an author of the question' do
      it 'returns false' do
        expect(not_author_user.author_of?(question)).to be false
      end
    end
  end
end