class Reconciliation < ApplicationRecord
  belongs_to :bank_account
  has_many :registers, dependent: :destroy

  monetize :starting_balance_cents
  monetize :ending_balance_cents
  
end