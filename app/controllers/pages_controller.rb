class PagesController < ApplicationController
  
  def rankings
  	@users 						= User.where(approved: true).order('points DESC, wins DESC, losses DESC')
  	@user_most_games 	= Game.findPlayerMostGames(@users)
  	@user_most_losses = Game.findPlayerMostLosses(@users)
  	@user_high_perc		= Game.findPlayerMostWinPerc(@users)
  end

  def feed
  	@games = Game.all.order("created_at desc")
  end

  def faq
  end


end
