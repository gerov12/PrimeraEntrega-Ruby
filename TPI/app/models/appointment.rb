class Appointment < ApplicationRecord
  belongs_to :professional

  validates :date, presence: true, future: true, shift: true
  validates :surname, presence: true, format: {with: /\A[a-zA-Z]+\z/, message: 'must contain letters only'}
  validates :name, presence: true, format: {with: /\A[a-zA-Z]+\z/, message: 'must contain letters only'}
  validates :phone, presence: true

  def can_be_deleted?
    date > DateTime.now
  end

  def filter(date)
    
  end
end
