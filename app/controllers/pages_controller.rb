class PagesController < ApplicationController
  
  def rankings
  	@users = User.all
  end

  def faq
  end


end
