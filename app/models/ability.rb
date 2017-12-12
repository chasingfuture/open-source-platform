# Class handling permission definition for cancancan gem.
# For more information, please refer to cancancan documentation
class Ability

  include CanCan::Ability

  # Main function where permissions are defined for the specified input user
  # For more information, please refer to cancancan documentation
  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)

    #
    # Project
    #
    # anyone can access any projects
    # only owner can update a given project
    #
    can :read, Project
    can :update, Project, owner_id: user.id

    #
    # User
    #
    # anyone can access any users
    # current user can only update its own profile
    #
    can :read, User
    can :update, User, id: user.id


    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

end
