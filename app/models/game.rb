class Game < ApplicationRecord

	def self.add_result(winner, loser)
		# Store all users into array and save rank of winner and loser
		@all_ranks = User.all.order("points desc")
		win_rank = @all_ranks.index(winner) + 1
		los_rank = @all_ranks.index(loser) + 1


		# If both players have the same score, do normal point system
			# (this means if 5 plays have 0 points it still uses normal method)
		if winner.points === loser.points
			puts "======================="
			puts "POINTS ARE 0"
			puts "======================="

			winner.points += 3

		# Within 2 ranks. Winner is higher rank
		elsif los_rank > win_rank && los_rank < win_rank + 3
			puts "======================="
			puts "WINNER IS HIGHER RANK"
			puts "======================="

			winner.points += 2
			loser.points -= 1

		# Within 2 ranks. Winner is lower rank
		elsif win_rank > los_rank && win_rank < los_rank + 3
			puts "===================="
			puts "WINNER IS LOWER RANK"
			puts "===================="
			winner.points += 3
			loser.points -= 2

		# Winner is 3 or more ranks above loser
		elsif los_rank >= win_rank + 3
			puts "===================="
			puts "WINNER IS LOWER RANK"
			puts "===================="
			winner.points += 1

		# Winner is 3 or more ranks below loser
		elsif win_rank >= los_rank + 3
			puts "===================="
			puts "WINNER IS LOWER RANK"
			puts "===================="
			winner.points += 5
			loser.points -= 5
		end

		# Check for negative points and reset to 0
		if loser.points < 0
			puts "======================="
			puts "RESETING LOSER SCORE"
			puts "======================="
			loser.points = 0
		end

		winner.wins += 1
		winner.save
		loser.losses += 1
		loser.save


	end
		


end
