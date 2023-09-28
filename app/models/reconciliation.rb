class Reconciliation < ApplicationRecord
  belongs_to :bank_account
  has_many :registers, dependent: :destroy

  monetize :starting_balance_cents, numericality: true
  monetize :ending_balance_cents, numericality: true
  
  validates :start_at, :end_at, presence: true
  validates :start_at, comparison: { greater_than: :end_at }

end