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

		context "validating form inputs"

			it "should return true if names are identical" do 
				game = build(:game, winner_name: "Freddo", loser_name: "Freddo")
				expect(Game.checkSameName(game)).to be_truthy
			end

			it "should return true if name is empty" do
				winner_name = ""
				expect(Game.checkEmpty(winner_name)).to be_truthy
			end
		end

		context "calculating points" do

			it ""

		end

	end
end












# type