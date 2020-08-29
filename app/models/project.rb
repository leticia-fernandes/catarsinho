class Project < ApplicationRecord
  MAX_GOAL = 500.freeze

  belongs_to :user, class_name: 'User'

  validates :title, :description, :goal, :closing_date, :user, presence: true
  validates :title, length: { maximum: 64 }
  validates :description, length: { maximum: 512 }
  validates :goal, numericality: { greater_than: 0, less_than_or_equal_to: MAX_GOAL }
  validates :closing_date, inclusion: { in: ->(closing_date) { (Date.tomorrow...Date.today+30.days) } }
end
