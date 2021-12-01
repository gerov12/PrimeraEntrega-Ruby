class Professional < ApplicationRecord
    has_many :appointments, dependent: :restrict_with_error
    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}
end
