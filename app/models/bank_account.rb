class BankAccount < ApplicationRecord
  belongs_to :foundation
  has_many :reconciliations, dependent: :destroy
  has_many :registers, dependent: :destroy
  
  monetize :starting_balance_cents
  monetize :balance_cents

  validates :full_name, presence: true, uniqueness: { scope: :foundation_id }
end
