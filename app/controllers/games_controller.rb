class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.new
    @users = User.all
  end

  # GET /games/new
  def new
    @game = Game.new
    @users = User.all
    authorize @game
  end

  # GET /games/1/edit
  def edit
    authorize @game
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)

    # Check if the both winner and loser names are the same
    if Game.checkSameName(@game)
      flash.now[:alert] = 'Names are the same'
      render :new

    # Check if winner name is empty
    elsif Game.checkEmpty(@game.winner_name)
      flash.now[:alert] = 'Please pick the winning player'
      render :new
      
    # Check if loser name is empty
    elsif Game.checkEmpty(@game.loser_name)
      flash.now[:alert] = 'Please pick the losing player'
      render :new


    # Calculate the results
    else
      @winner = User.find_by_username(@game.winner_name)
      @loser = User.find_by_username(@game.loser_name)

      Game.add_result(@winner, @loser)
      authorize @game
      respond_to do |format|
        if @game.save
          format.html { redirect_to root_path, notice: 'Game was successfully created.' }
          format.json { render :show, status: :created, location: @game }
        else
          format.html { render :new }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    authorize @game
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    authorize @game
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:winner_name, :loser_name, :winner_score, :loser_score)
    end
end
