class PagesController < ApplicationController
  
  def rankings
  	@users = User.where(approved: true).order('points DESC, wins DESC')
  end

  def feed
  	@games = Game.all.order("created_at desc")
  end

  def faq
  end


end
