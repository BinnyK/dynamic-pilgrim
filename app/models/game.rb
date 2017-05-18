class Game < ApplicationRecord
	validates :winner_name, :winner_score, :loser_name, :loser_score, presence: true

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

	# Check if winner name and loser name are identical
	def self.checkSameName(result)
		result.winner_name === result.loser_name ? true : false
	end

	# Check if username is empty
	def self.checkEmpty(username)
		username === "" ? true : false
	end


	# Calculate points
	def self.addResult(all_ranks, winner, loser)

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
			loser.points -= 2

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

	# Find player with most games played
	def self.findPlayerMostGames(array)

		highest_games = 0
		result_player = ""

		array.each do |user|

			user_total = user.wins + user.losses

			if user_total > highest_games
				highest_games = user_total
				result_player = user
			end
		end

		return result_player
	end

	# Find player with most losses
	def self.findPlayerMostLosses(array)
		total_losses = 0
		player = ""

		array.each do |user|
			if user.losses > total_losses
				total_losses = user.losses
				player = user
			end
		end

		return player
	end

	# Find player with highest win percentage
	def self.findPlayerMostWinPerc(array)

		win_percentage = 0
		player = ""

		array.each do |user|

			games = user.wins.to_f + user.losses.to_f

			if games >= 5
				percentage = (user.wins / games) * 100

				if percentage > win_percentage
					player = user
					win_percentage = percentage.to_i
				end
			end
		end

		return player

	end

	# Find afk user
	def self.findAFK(array)
		player = ""
		games = 20

		array.each do |user|
			user_games = user.wins + user.losses

			if user_games <= games
				games = user_games
				player = user
			end
		end
		return player

	end

	# Find player with most opponents
	def self.findMostOpponent(users, games)
		# Create count variable = 0
		opponent_count = 0
		# Create result user variable
		most_opponent = ""
		# Create empty array
		temp_array = []

		# Loop through each user
		users.each do |user|

			# then loop through each game.
			games.each do |game|
				# If user's username matches game.winner_name
				if user.username == game.winner_name
					# if empty array doesn't have game.loser_name
					if temp_array.include?(game.loser_name) == false
						# Push into empty array
						temp_array.push(game.loser_name)
					end

				# else if user's username matches game.loser_name
				elsif user.username == game.loser_name
					# if empty array doesn't have game.winner_name
					if temp_array.include?(game.winner_name) == false
						# Push into empty array
						temp_array.push(game.winner_name)
					end
				end

			end
			# If empty array count > count variable
			if temp_array.count > opponent_count
				# count variable = empty array.count
				opponent_count = temp_array.count
				# result user = user
				most_opponent = user
				# reset empty array
				temp_array = []
			else
				# reset empty array
				temp_array = []

			end
		end
		# return result user
		return most_opponent
	end


	# This method is just to update all game ids. This is to back track
	def self.updateGameIds(games)

		games.each do |game|
			user_winner = User.where(username: game.winner_name).first
			user_loser 	= User.where(username: game.loser_name).first

			game.winner_id = user_winner.id
			game.loser_id  = user_loser.id
			game.save
		end
	end

	# Return the total number of games shared between 2 players

	def self.calculateCommonGames(games, player1, player2)
		common_games = []
		# loop through all games
		games.each do |game|
			# if (winner.id == player1.id && loser.id == player2.id ) || (winner.id == player 2 && loser.id == player1.id )
			if ((game.winner_id == player1.id && game.loser_id == player2.id) ||
				  (game.winner_id == player2.id && game.loser_id == player1.id))
			# increment counter
				common_games.push(game)
			end
		end
		common_games
	end

	def self.calculateWinLoss(games, player)
		counter = 0
		games.each do |game|
			if (game.winner_id == player.id)
				counter += 1
			end
		end
		[counter, games.count - counter]
	end

	def self.calculateSets(games, player)
		counter = 0
		games.each do |game|
			if (game.winner_id == player.id)
				counter += game.winner_score
			end

			if (game.loser_id == player.id)
				counter += game.loser_score
			end
		end
		counter
	end

end
