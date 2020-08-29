require 'rails_helper'

RSpec.describe Donation, type: :model do
  describe "Attributos" do
    it { is_expected.to respond_to(:project) }
    it { is_expected.to respond_to(:donator) }
    it { is_expected.to respond_to(:value) }
  end

  describe "Relações" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:donator) }
  end

  describe "Validações" do
    it { is_expected.to validate_presence_of(:project) }
    it { is_expected.to validate_presence_of(:donator) }
    it { is_expected.to validate_presence_of(:value) }

    it { is_expected.to validate_numericality_of(:value).is_greater_than(0) }
  end

  describe "Factory" do
    it { expect(build(:donation)).to be_a Donation }
    it { expect(build(:donation)).to be_valid }
  end
end
