module Api
  module V1
    class GamesController < ApplicationController
      def index
        @games = Game.all.order("created_at desc")
        render json: @games, status: 200
      end
    end
  end
end