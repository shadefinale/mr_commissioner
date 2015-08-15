require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  context "password validation" do

    it "shouldn't be shorter than 8 characters" do
      user.password = "f" * 7
      user.password_confirmation = "f" * 7
      expect(user).not_to be_valid
    end

    it "shouldn't be longer than 24 characters" do
      user.password = "f" * 25
      user.password_confirmation = "f" * 25
      expect(user).not_to be_valid
    end

    it "should be at least 8 characters" do
      user.password = "f" * 8
      user.password_confirmation = "f" * 8
      expect(user).to be_valid
    end

    it "should be up to 24 characters" do
      user.password = "f" * 24
      user.password_confirmation = "f" * 24
      expect(user).to be_valid
    end

    it "shouldn't be valid if passwords don't match" do
      user.password = "f" * 8
      user.password_confirmation = "f" * 9
      expect(user).not_to be_valid
    end

  end

  context "username validations" do

    it "should be unique" do
      create(:user, username: "foofoo")
      other_user = build(:user, username: "foofoo")
      expect(other_user).not_to be_valid
    end

    it "shouldn't be shorter than 4 characters" do
      user.username = "f" * 3
      expect(user).not_to be_valid
    end

    it "shouldn't be longer than 20 characters" do
      user.username = "f" * 21
      expect(user).not_to be_valid
    end

    it "should be at least 4 characters" do
      user.username = "f" * 4
      expect(user).to be_valid
    end

    it "should be up to 20 characters" do
      user.username = "f" * 20
      expect(user).to be_valid
    end

  end


end
