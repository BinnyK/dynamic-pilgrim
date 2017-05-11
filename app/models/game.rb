class Game < ApplicationRecord
	validates :winner_name, :winner_score, :loser_name, :loser_score, presence: true

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


				# If empty array count > count variable
				if temp_array.count > opponent_count
					# count variable = empty array.count
					opponent_count = temp_array.count
					# result user = user
					most_opponent = user
				else
					# reset empty array
					temp_array = []
				end
			end
		end
		# return result user
		return most_opponent
	end

end

















