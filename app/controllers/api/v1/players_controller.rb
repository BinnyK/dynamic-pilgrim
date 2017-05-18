module Api
  module V1
    class PlayersController < ApplicationController
      def index
        @users = User.where(approved: true).order('points DESC, wins DESC, losses DESC')
        render json: @users.as_json(except: [:email, :avatar, :updated_at, :approved]), status: 200
      end
    end
  end
end