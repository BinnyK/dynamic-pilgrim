class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @games = Game.all.order("created_at desc")
  end
end
