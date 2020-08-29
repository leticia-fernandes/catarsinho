class Donation < ApplicationRecord

  belongs_to :project, class_name: 'Project'
  belongs_to :donator, class_name: 'User', foreign_key: :user_id

  validates :project, :donator, :value, presence: true
  validates :value, numericality: { greater_than: 0 }
end
