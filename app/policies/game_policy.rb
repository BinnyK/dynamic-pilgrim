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
    @user.admin?
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
