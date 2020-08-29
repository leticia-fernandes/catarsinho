require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Attributos" do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:name)  }
  end

  describe "Relações" do
    it { is_expected.to have_many(:projects) }
    it { is_expected.to have_many(:donations) }
  end

  describe "Validações" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe "Factory" do
    it { expect(build(:user)).to be_a User }
    it { expect(build(:user)).to be_valid }
  end
end
