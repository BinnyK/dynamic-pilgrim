module Api
  module V1
    class PlayersController < ApplicationController
      def index
        @users = User.where(approved: true).order('points DESC, wins DESC, losses DESC')
        render json: @users, status: 200
      end
    end
  end
end