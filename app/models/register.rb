class Register < ApplicationRecord
  belongs_to :bank_account
  belongs_to :reconciliation
  has_many :grants, dependent: :destroy
  has_many :payouts, dependent: :destroy

  monetize :amount_cents
end