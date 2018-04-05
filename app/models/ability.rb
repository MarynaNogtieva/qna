class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    # Define abilities for the passed in user here. For example: 
    # user ||= User.new # guest user (not logged in)
    load_aliases
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  protected

  def load_aliases
    alias_action :update, :destroy, to: :update_destory
    alias_action :vote_for, :vote_against, to: :vote
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [ Question, Answer, Comment ]
    can :update_destory, [ Question, Answer ], { user_id: user.id }
    can :comment, [Question, Answer]

    can :best_answer, Answer, question: { user_id: user.id }
    can :vote, [Question, Answer] do |item|
      !user.author_of?(item)
    end

    can :reset_vote, [Question, Answer] do |item|
      item.votes.where(user: user).where(votable: item) && !user.author_of?(item)
    end
  end
end
