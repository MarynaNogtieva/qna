class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes

  def author_of?(item)
    id == item.user_id
  end
end
