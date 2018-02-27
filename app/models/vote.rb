class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true, optional: true
  belongs_to :user

  validates :score, inclusion: [-1, 0, 1]
end
