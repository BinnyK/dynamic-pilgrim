require 'faker'

FactoryGirl.define do
	factory :game do |f|
		f.winner_name { Faker::Name.first_name }
		f.winner_score 3
		f.loser_name { Faker::Name.first_name }
		f.loser_score 0
	end

	

end