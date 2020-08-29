class Project < ApplicationRecord
  MAX_GOAL = 500.freeze

  belongs_to :user, class_name: 'User'
  has_many :donations, class_name: 'Donation'
  has_many :donators, class_name: 'User', through: :donations

  validates :title, :description, :goal, :closing_date, :user, presence: true
  validates :title, length: { maximum: 64 }
  validates :description, length: { maximum: 512 }
  validates :goal, numericality: { greater_than: 0, less_than_or_equal_to: MAX_GOAL }
  validates :closing_date, inclusion: { in: ->(closing_date) { (Date.tomorrow...Date.today+30.days) } }

  def is_open?
    (Date.today...Date.today+30.days).include?(closing_date)
  end

  def total_donations
    donations.sum(:value)
  end
end
