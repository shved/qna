class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :mark_best, Answer do |answer|
      user.owner_of?(answer.question)
    end

    can :vote_up, [Question, Answer] do |resource|
      user.can_vote?(resource)
    end

    can :vote_down, [Question, Answer] do |resource|
      user.can_vote?(resource)
    end

    can :unvote, [Question, Answer] do |resource|
      user.voted_for?(resource)
    end
  end
end
