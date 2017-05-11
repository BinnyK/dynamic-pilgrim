class ApiController < ApplicationController
  def games
    @games = Game.all.order("created_at desc")
    render json: @games
  end
  # def users
  #   @users = User.all
  #   render json: @user
  # end
end
