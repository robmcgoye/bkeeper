class Register < ApplicationRecord
  belongs_to :bank_account
  has_many :reconciliation_items
  has_many :reconciliations, through: :reconciliation_items
  has_one :contribution
    # , dependent: :destroy
  monetize :amount_cents, numericality: {greater_than: 0}

  enum :transaction_type, { debit: 0, credit: 1 }, default: :debit
  # enum transaction_type: [:debit, :credit]

  validates :transaction_at, presence: { message: "must have date of transaction" } 

  after_save do
    new_balance = credit? ? bank_account.balance + amount : bank_account.balance - amount
    bank_account.update_balance!(new_balance)
  end
end