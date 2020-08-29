require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "Attributos" do
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:goal) }
    it { is_expected.to respond_to(:closing_date) }
    it { is_expected.to respond_to(:user) }
  end

  describe "Relações" do
    it { is_expected.to belong_to(:user) }
  end

  describe "Validações" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:goal) }
    it { is_expected.to validate_presence_of(:closing_date) }
    it { is_expected.to validate_presence_of(:user) }

    it { is_expected.to validate_length_of(:title).is_at_most(64) }
    it { is_expected.to validate_length_of(:description).is_at_most(512) }
    it { is_expected.to validate_numericality_of(:goal).
                        is_greater_than(0).
                        is_less_than_or_equal_to(Project::MAX_GOAL) }
    it { is_expected.to validate_inclusion_of(:closing_date).in_range((Date.tomorrow)...(Date.today+30.days)) }
  end

  describe "Factory" do
    it { expect(build(:project)).to be_a Project }
    it { expect(build(:project)).to be_valid }
  end
end
