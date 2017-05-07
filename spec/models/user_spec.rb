require 'spec_helper'

describe User do

	describe "validations" do
		it "has a valid factory" do 
			expect(build(:user)).to be_truthy
		end

		it "is invalid without a username" do
			expect(build(:user, username: nil)).to be_invalid
		end

		it "is invalid without a unique username" do
			user = create(:user, username: "Freddo")
			expect(build(:user, username: "Freddo")).to be_invalid
		end

		it "is invalid without an email" do
			expect(build(:user, email: nil)).to be_invalid
		end

	end

	describe "default values" do

		it "has default wins of 0" do
			user = build(:user)
			expect(user.wins).to eq(0)
		end

		it "has default losses of 0" do
			user = build(:user)
			expect(user.losses).to eq 0
		end

		it "has default points of 0" do
			user = build(:user)
			expect(user.points).to eq 0
		end

		it "has default role of user" do
			user = create(:user)
			expect(user.has_role? :player).to be_truthy
		end

		it "is not an admin" do
			user = create(:user)
			expect(user.has_role? :admin).to be_falsey
		end

	end

end










# Type