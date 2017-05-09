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

    	@all_ranks = [
    		@rank1,
    		@rank2,
    		@rank3,
    		@rank4,
    		@rank5,
    		@rank6,
    		@rank7,
    		@rank8
    	]

	  end

		context "winner and loser have same points" do

			it "should award winner 3 points" do
				Game.add_result(@all_ranks, @rank7, @rank8)
				expect(@rank7.points).to eq 3
			end

			it "should penalise loser 2 points" do
				Game.add_result(@all_ranks, @rank5, @rank6)
				expect(@rank6.points).to eq 8
			end

		end

		context "winner and loser are within 2 ranks" do

			it "should award higher rank winner 2 points" do
				Game.add_result(@all_ranks, @rank1, @rank2)
				expect(@rank1.points).to eq 32
			end

			it "should penalise lower rank loser 1 point" do
				Game.add_result(@all_ranks, @rank1, @rank2)
				expect(@rank2.points).to eq 24
			end

			it "should award lower rank winner 3 points" do 
				Game.add_result(@all_ranks, @rank2, @rank1)
				expect(@rank2.points).to eq 28
			end

			it "should penalise higher rank loser 2 points" do
				Game.add_result(@all_ranks, @rank2, @rank1)
				expect(@rank1.points).to eq 28
			end

		end

		context "winner and loser are 3 or more ranks apart" do

			it "should award higher rank winner 1 point"
			it "should not penalise lower rank loser"
			it "should award lower rank winner 5 points"
			it "should penalise higher rank 5 points"

		end

		context "player's point is smaller than 0" do
			it "should set point to 0"
		end

	end

end












# type