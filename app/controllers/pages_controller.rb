class PagesController < ApplicationController
  
  def rankings
  	@users = User.all.order('points DESC')
  end

  def feed
  	@games = Game.all.order("created_at desc")
  end

  def faq
  end


end
