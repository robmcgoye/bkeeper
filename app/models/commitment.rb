class Commitment < ApplicationRecord
  belongs_to :organization
  has_many :payouts, dependent: :destroy
  monetize :amount_cents

  # validates 
end