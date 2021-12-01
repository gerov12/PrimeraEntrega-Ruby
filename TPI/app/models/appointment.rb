class Appointment < ApplicationRecord
  belongs_to :professional

  validates :date, presence: true
  validates :surname, presence: true
  validates :name, presence: true
  validates :phone, presence: true
end
