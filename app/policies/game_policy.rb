class GamePolicy < ApplicationPolicy
  attr_reader :user, :game

  def initialize(user, game)
    @user = user
    @game = game
  end

  def new?
    @user.admin?
  end

  def update?
<<<<<<< HEAD
    @user.admin?
=======
    @user.admin? or not item.published?
>>>>>>> c8434d1b1fddac891b901dae210e115b8cb476c8
  end

  def destroy?
   @user.admin?
  end

  def create?
    @user.admin?
  end

  class Scope < Scope
    def resolve
     scope
    end
  end

end
