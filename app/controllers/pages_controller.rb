class PagesController < ApplicationController

  def rankings
  	@users 						= User.where(approved: true).order('points DESC, wins DESC, losses DESC')
  	@user_most_games 	= Game.findPlayerMostGames(@users)
  	@user_most_losses = Game.findPlayerMostLosses(@users)
  	@user_high_perc		= Game.findPlayerMostWinPerc(@users)
  	@user_afk					= Game.findAFK(@users)

  	@games = Game.all

  	@user_most_opp		= Game.findMostOpponent(@users, @games)
  end

  def feed
      @q = Game.search(params[:q])
      @games = Game.all.order("created_at desc")
      @games = @q.result(distinct: true)
  end


  def faq
  end


end
