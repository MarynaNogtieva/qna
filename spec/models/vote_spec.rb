require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { is_expected.to allow_value(-1).for(:score) }
  it { is_expected.to allow_value(0).for(:score) }
  it { is_expected.to allow_value(1).for(:score) }
  it { should belong_to :user }
end
