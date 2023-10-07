class Reconciliation < ApplicationRecord
  belongs_to :bank_account
  has_many :reconciliation_items
  has_many :registers, through: :reconciliation_items

  monetize :starting_balance_cents, numericality: true
  monetize :ending_balance_cents, numericality: true
  
  validates :start_at, :end_at, presence: true
  validates :start_at, comparison: { greater_than: :end_at }

  # after_save :update_account_balance

  # def update_account_balance
  #   account.update_balance!(ending_balance)
  # end
end