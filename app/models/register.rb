class Register < ApplicationRecord
  belongs_to :bank_account
  belongs_to :reconciliation, optional: true
  has_one :contribution
    # , dependent: :destroy
  monetize :amount_cents, numericality: {greater_than: 0}

  enum :transaction_type, { debit: 0, credit: 1 }, default: :debit

  validates :transaction_at, presence: { message: "must have date of transaction" } 
end