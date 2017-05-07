require 'spec_helper'

describe User do

	it "has a valid factory" do 
		expect(FactoryGirl.build(:user).save).to be_truthy
	end

	it "is invalid without a username" do
		expect(FactoryGirl.build(:user, username: nil).save).to be_falsey
	end
	it "is invalid without a unique username"
	it "is invalid without an email"

end