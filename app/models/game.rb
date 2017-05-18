class Game < ApplicationRecord
	validates :winner_name, :winner_score, :loser_name, :loser_score, presence: true

	def self.checkSameName(result)
		result.winner_name === result.loser_name ? true : false
	end

	def self.checkEmpty(result)
		result === "" ? true : false
	end

# ELO System based off https://www.chessclub.com/user/help/ratings

	def self.expectedScore(player_elo, opponent_elo)
		expected = 1/(1+10**((opponent_elo-player_elo)/400)).rationalize
	end

	def self.setElo(winner, loser)
		# k factor helps shape how big/small changes in ELO should be
		k = 32

		# The % expected chance that the winner would win based off current ELO vs opponent's ELO
		winner_expected = expectedScore(winner.elo.to_f, loser.elo.to_f)
		puts "winner_expected: #{winner_expected}"
		# The % expected chance that the loser would win based off current ELO vs opponent's ELO
		loser_expected = expectedScore(loser.elo.to_f, winner.elo.to_f)
		puts "loser_expected: #{loser_expected}"

		# Assigning the new ELO for players based off the expected chance of winning and the k factor 
		winner.elo = winner.elo + (k*(1 - winner_expected))
		puts "winner.elo: #{winner.elo}"
		loser.elo = loser.elo + (k*(0 - loser_expected))
		puts "loser.elo: #{loser.elo}"

		# Save the elo of each player
		winner.save
		loser.save
	end


	def self.add_result(all_ranks, winner, loser)
		# Store all users into array and save rank of winner and loser
		win_rank = all_ranks.index(winner) + 1
		los_rank = all_ranks.index(loser) + 1

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
			puts "WINNER IS HIGHER RANK WITHIN 2"
			puts "======================="

			winner.points += 2
			loser.points -= 1

		# Within 2 ranks. Winner is lower rank
		elsif win_rank > los_rank && win_rank < los_rank + 3
			puts "===================="
			puts "WINNER IS LOWER RANK WITHIN 2"
			puts "===================="
			winner.points += 3
			loser.points -= 2

		# Winner is 3 or more ranks above loser
		elsif los_rank >= win_rank + 3
			puts "===================="
			puts "WINNER IS HIGHER RANK BY MORE THAN 2"
			puts "===================="
			winner.points += 1

		# Winner is 3 or more ranks below loser
		elsif win_rank >= los_rank + 3
			puts "===================="
			puts "WINNER IS LOWER RANK BY MORE THAN 2"
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
