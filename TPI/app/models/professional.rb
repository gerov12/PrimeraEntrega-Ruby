class Professional < ApplicationRecord
    has_many :appointments, dependent: :delete_all
    validates :name, presence: true, format: {with: /\A[a-zA-Z]+\z/, message: 'must contain letters only'}, uniqueness: { case_sensitive: false }, length: {maximum: 50}

    def can_be_deleted?
        !appointments.where('date > ?', DateTime.now).exists?
    end
end
