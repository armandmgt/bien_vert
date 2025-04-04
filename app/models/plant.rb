class Plant < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :species, :watering_interval_days, presence: true
end
