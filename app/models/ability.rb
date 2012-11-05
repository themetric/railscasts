class Ability
  include CanCan::Ability

  def initialize(user)
    # A user that is not logged in 
    can :read, :episodes, ["published_at <= ?", Time.zone.now] do |episode|
      episode.published_at <= Time.now.utc
    end
    can :access, :info
    can :create, :feedback_messages
    can [:read, :create, :login, :sign_up, :unsubscribe], :users    

    if user
      can :logout, :users
      can :update, :users, :id => user.id
      unless user.banned?
        # Don't allow banned users to do any kind of commenting or revision 
        can :create, :comments
        can [:update, :destroy], :comments do |comment|
          comment.user_id == user.id
        end
      end

      if user.moderator?
        can :read, :episodes
        can :update, :episodes, :notes
        can [:update, :destroy, :index], :comments
        can :ban, :users
        can :revert, :versions
      end

      if user.admin?
        can :access, :all
      end
    end
  end
end
