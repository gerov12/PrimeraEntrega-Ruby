class Appointment < ApplicationRecord
  belongs_to :professional

  validates :date, presence: true, future: true, shift: true
  validates :surname, presence: true, format: {with: /\A[a-zA-Z]+\z/, message: 'must contain letters only'}
  validates :name, presence: true, format: {with: /\A[a-zA-Z]+\z/, message: 'must contain letters only'}
  validates :phone, presence: true
  scope :filter_by_date, -> (date_f) {where("strftime('%Y-%m-%d', date) = ?", date_f)}

  def can_be_deleted?
    date > DateTime.now
  end

  def filter(date)
    
  end
end
