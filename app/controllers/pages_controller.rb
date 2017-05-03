class PagesController < ApplicationController
  
  def rankings
  	@users = User.all.order('points DESC')
  end

  def faq
  end


end
