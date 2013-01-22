class Ability
  include CanCan::Ability

  def initialize(user)
    # A user that is not logged in 
    can :read, Episode, ["published_at <= ?", Time.zone.now] do |episode|
      episode.published_at <= Time.now.utc      
    end       
    cannot :view_content, Episode do |episode|
      episode.protected == true 
    end   
    can :view_content, Episode do |episode|
      [false, nil].include?(episode.protected)
    end   
    can :create, FeedbackMessage
    can [:read, :unsubscribe], User    

    if user
      can :read, Comment 
      can :read, Episode, ["published_at <= ?", Time.zone.now] do |episode|
        episode.published_at <= Time.now.utc      
      end
      can :view_content, Episode 
      can [:read, :unsubscribe], User       
      can :update, User, :id => user.id
      unless user.banned?
        # Don't allow banned users to do any kind of commenting or revision 
        can :create, Comment
        # Can update and destroy own comments 
        can [:update, :destroy], Comment, :user_id => user.id
      end

      if user.moderator?     
        #can :update, :episodes, :notes
        can :manage, Episode
        can [:update, :destroy, :index], Comment
        can :ban, User
        can :revert, :versions
      end

      if user.admin?
        # Can create episodes, etc. 
        can :manage, :all
      end
    end
  end
end
