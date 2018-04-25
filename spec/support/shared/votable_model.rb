shared_examples_for 'Votable Model' do
  let(:user) { @user || create(:user) }
  let(:votable_object) { create(object_name, user: user) }

  it 'should create vote for' do
    expect { votable_object.vote_for(user) }.to change(Vote, :count).by(1)
  end

  it 'should create vote against' do
    expect { votable_object.vote_against(user) }.to change(Vote, :count).by(1)
  end

  it 'should set vote for to 1' do
    votable_object.vote_for(user)
    expect(votable_object.vote_score).to eq 1
  end

  it 'should set vote against to -1' do
    votable_object.vote_against(user)
    expect(votable_object.vote_score).to eq -1
  end

  it 'should check if the question was voted for' do
    votable_object.vote_for(user)
    expect(votable_object).to be_voted(user)
  end

  it 'should get a question sum' do
    votable_object.vote_for(user)
    expect(votable_object.vote_score).to eq 1
  end

  it 'should reset score by removing record for this vote' do
    votable_object.vote_for(user)
    expect { votable_object.reset_vote(user) }.to change(Vote, :count).by(-1)
  end
end