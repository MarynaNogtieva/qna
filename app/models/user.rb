class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions, dependent: :destroy
  has_many :answers
  has_many :votes
  has_many :authorizations

  has_many :subscriptions, dependent: :destroy

  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    return unless auth.info && auth.info[:email]

    email = auth.info[:email]
    user = User.where(email: email).first
  
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.save!
    end

    user.create_authorization(auth) 

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def add_subscription(question)
    question.subscriptions.create!(user_id: self.id)
  end

  def subscribed?(question)
    question.subscriptions.exists?(user: self)
  end

  def remove_subscription(question)
    question.subscriptions.where(user_id: self.id).destroy_all
  end
end

