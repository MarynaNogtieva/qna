shared_examples_for 'Votable Controller' do
  let(:user) { @user || create(:user) }
  let(:votable_object) { create(object_name, user: user) }
  let(:non_author) { create(:user) }
  let(:non_author_votable_object) { create(object_name, user: non_author) }

  describe 'POST #vote_for' do
    sign_in_user

    it 'increases "voted-for" score for non-author votable_object' do
      expect { post :vote_for, params: { id: non_author_votable_object } }.to change(Vote, :count).by(1)
    end

    it 'does not allow an author to vote for his/her votable_object' do
      expect { post :vote_for, params: { id: votable_object } }.to_not change(Vote, :count)
    end
  end

  describe 'POST #vote_against' do
    sign_in_user

    it 'increases "voted-against" score for non-author votable_object' do
      expect { post :vote_against, params: { id: non_author_votable_object } }.to change(Vote, :count).by(1)
    end

    it 'does not allow an author to vote against his/her votable_object' do
      expect { post :vote_against, params: { id: votable_object } }.to_not change(Vote, :count)
    end
  end

  describe 'POST #reset_vote' do
    sign_in_user
    before { post :vote_for, params: { id: non_author_votable_object } }

    it 'resetes vote' do
      expect { post :reset_vote, params: { id: non_author_votable_object } }.to change(Vote, :count).by(-1)
    end

    it 'does not allow an author to reset vote for his/her votable_object' do
      expect { post :reset_vote, params: { id: votable_object } }.to_not change(Vote, :count)
    end
  end
end