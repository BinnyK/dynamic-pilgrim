require 'spec_helper'

describe Game do

	describe "validation" do

		it "has a valid factory" do
			expect(build(:game)).to be_truthy
		end

		it "is invalid without a winner name" do
			expect(build(:game).winner_name).to_not be_empty
		end

		it "is invalid without a loser name" do
			expect(build(:game).loser_name).to_not be_empty
		end

		it "is invalid if winner name and loser name are the same" do
			game = build(:game)
			expect(game.winner_name).to_not eq(game.loser_name)
		end

		it "is valid if winner score is 3" do
			expect(build(:game).winner_score).to eq 3
		end

		it "is invalid if loser score is less than 0 or greater than 2" do
			expect(build(:game).loser_score).to eq(0).or eq(1).or eq(2)
		end

	end

	describe "class methods" do

		context "validating form inputs" do

			it "should return true if names are identical" do
				game = build(:game, winner_name: "Freddo", loser_name: "Freddo")
				expect(Game.checkSameName(game)).to be_truthy
			end

			it "should return true if name is empty" do
				winner_name = ""
				expect(Game.checkEmpty(winner_name)).to be_truthy
			end

		end

	end
	
	describe "calculating game result" do
		
		before(:each) do
			@rank1 = build(:user, username: "rank1", points: 30)
			@rank2 = build(:user, username: "rank2", points: 25)
			@rank3 = build(:user, username: "rank3", points: 20)
			@rank4 = build(:user, username: "rank4", points: 15)
			@rank5 = build(:user, username: "rank5", points: 10)
			@rank6 = build(:user, username: "rank6", points: 10)
			@rank7 = build(:user, username: "rank7", points: 0)
			@rank8 = build(:user, username: "rank8", points: 0)
			@rankMinus = build(:user, username: "rankMinus", points: -3)

    	@all_ranks = [
    		@rank1,
    		@rank2,
    		@rank3,
    		@rank4,
    		@rank5,
    		@rank6,
    		@rank7,
    		@rank8,
    		@rankMinus
    	]

	  end

		context "winner and loser have same points" do

			it "should award winner 3 points" do
				Game.addResult(@all_ranks, @rank7, @rank8)
				expect(@rank7.points).to eq 3
			end

			it "should penalise loser 2 points" do
				Game.addResult(@all_ranks, @rank5, @rank6)
				expect(@rank6.points).to eq 8
			end

		end

		context "winner and loser are within 2 ranks" do

			it "should award higher rank winner 2 points" do
				Game.addResult(@all_ranks, @rank1, @rank2)
				expect(@rank1.points).to eq 32
			end

			it "should penalise lower rank loser 1 point" do
				Game.addResult(@all_ranks, @rank1, @rank2)
				expect(@rank2.points).to eq 24
			end

			it "should award lower rank winner 3 points" do 
				Game.addResult(@all_ranks, @rank2, @rank1)
				expect(@rank2.points).to eq 28
			end

			it "should penalise higher rank loser 2 points" do
				Game.addResult(@all_ranks, @rank2, @rank1)
				expect(@rank1.points).to eq 28
			end

		end

		context "winner and loser are 3 or more ranks apart" do

			it "should award higher rank winner 1 point" do
				Game.addResult(@all_ranks, @rank1, @rank5)
				expect(@rank1.points).to eq 31
			end

			it "should not penalise lower rank loser" do
				Game.addResult(@all_ranks, @rank1, @rank5)
				expect(@rank5.points).to eq 10
			end

			it "should award lower rank winner 5 points" do
				Game.addResult(@all_ranks, @rank5, @rank1)
				expect(@rank5.points).to eq 15
			end

			it "should penalise higher rank 5 points" do
				Game.addResult(@all_ranks, @rank5, @rank1)
				expect(@rank1.points).to eq 25
			end

		end

		context "player's point is 0 or lower" do
			
			it "should set point to 0" do 
				Game.addResult(@all_ranks, @rank6, @rankMinus)
				expect(@rankMinus.points).to be 0
			end

			it "should not deduct points past 0" do
				Game.addResult(@all_ranks, @rankMinus, @rank8)
				expect(@rank8.points).to be 0
			end

		end
	end

	describe "calculating badge methods" do

		before(:each) do
			@player1 = build(:user, username: "player1", wins: 30, losses: 30)
			@player2 = build(:user, username: "player2", wins: 25, losses: 25)
			@player3 = build(:user, username: "player3", wins: 20, losses: 10)
			@player4 = build(:user, username: "player4", wins: 15, losses: 15)
			@all_users = [@player1, @player2, @player3, @player4]
		end

		context "player has most amount of games" do

			it "should return player with most amount of games" do

				player = Game.findPlayerMostGames(@all_users)
				expect(player).to be @player1

			end

		end

		context "player has the most amount of losses" do

			it "should return player with the most amount of losses" do
				player = Game.findPlayerMostLosses(@all_users)
				expect(player).to be @player1
			end

		end

		context "player has the highest win percentage" do
			
			it "should return player with the highest win percentage" do
				player = Game.findPlayerMostWinPerc(@all_users)
				expect(player).to be @player3
			end

			it "should only work for over 5 total games" do
				player1 = build(:user, username: "player1", wins: 4, losses: 0)
				player2 = build(:user, username: "player2", wins: 10, losses: 2)
				player = Game.findPlayerMostWinPerc([player1, player2])
				expect(player).to be player2
			end

		end

		context "player has not played recently" do

			it "should return player who hasn't played a game" do
				user1 = build(:user, username: "user1", wins: 0, losses: 0)
				user2 = build(:user, username: "user2", wins: 2, losses: 0)

				player = Game.findAFK([user1, user2])
				expect(player).to be user1
			end

		end

		context "player has versed multiple opponents" do 

			it "should return player with the most number of unique opponents" do
				game1 = build(:game, winner_name: "player1", loser_name: "player2")
				game2 = build(:game, winner_name: "player2", loser_name: "player1")
				game3 = build(:game, winner_name: "player3", loser_name: "player4")
				game4 = build(:game, winner_name: "player1", loser_name: "player4")
				game5 = build(:game, winner_name: "player3", loser_name: "player1")
				games = [game1, game2, game3, game4, game5]

				username = Game.findMostOpponent(@all_users, games)
				expect(username).to be @player1
			end

		end

	end

	describe "calculating head to head" do

		before(:each) do
			@player1 = build(:user, id: 1,username: "player1", wins: 30, losses: 30)
			@player2 = build(:user, id: 2,username: "player2", wins: 25, losses: 25)

			game1 = build(:game, winner_id: @player1.id, winner_name: "player1", winner_score: 3, loser_id: @player2.id, loser_name: "player2", loser_score: 1)
			game2 = build(:game, winner_id: @player2.id, winner_name: "player2", winner_score: 3, loser_id: @player1.id, loser_name: "player1", loser_score: 1)
			game3 = build(:game, winner_id: nil, winner_name: "player3", winner_score: 3, loser_id:nil , loser_name: "player4", loser_score: 1)
			game4 = build(:game, winner_id: @player1.id, winner_name: "player1", winner_score: 3, loser_id:nil , loser_name: "player4", loser_score: 1)
			game5 = build(:game, winner_id: nil, winner_name: "player3", winner_score: 3, loser_id: @player1.id, loser_name: "player1", loser_score: 1)
			game6 = build(:game, winner_id: @player2.id, winner_name: "player2", winner_score: 3, loser_id: @player1.id, loser_name: "player1", loser_score: 1)
			@games = [game1, game2, game3, game4, game5, game6]
		end

		context "calculate total common games played" do

			it "should return total games played against each other" do
				common_games = Game.calculateCommonGames(@games, @player1, @player2)
				expect(common_games.count).to eq 3
			end

			it "should return total wins and losses between total games" do
				common_games = Game.calculateCommonGames(@games, @player1, @player2)
				results = Game.calculateWinLoss(common_games, @player1)
				expect(results).to eq [1,2]
			end

			it "should return total sets won by each player" do
				common_games = Game.calculateCommonGames(@games, @player1, @player2)
				results1 = Game.calculateSets(common_games, @player1)
				results2 = Game.calculateSets(common_games, @player2)
				expect(results1).to eq 5
				expect(results2).to eq 7

			end

		end

	end

end












# type
