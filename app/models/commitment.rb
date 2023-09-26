class Commitment < ApplicationRecord
  belongs_to :organization
  has_many :grants, dependent: :destroy
  monetize :amount_cents

  # validates 
end