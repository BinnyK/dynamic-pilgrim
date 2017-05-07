require 'faker'

FactoryGirl.define do
	factory :user do |f|
		f.username { Faker::Name.first_name }
		f.email { Faker::Internet.email }
		f.password { Faker::Internet.password(8) }
		f.approved false
	end
end