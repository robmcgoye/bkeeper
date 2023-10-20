class Check < ApplicationRecord
  belongs_to :bank_account
  has_many :reconciliation_items
  has_many :reconciliations, through: :reconciliation_items
  has_one :contribution
    # , dependent: :destroy
  monetize :amount_cents, numericality: {greater_than: 0}
  attribute :orginal_amount_cents
  monetize :orginal_amount_cents, allow_nil: true

  after_find :set_orginal_amount
  after_save :update_bank_account_balance
  before_destroy :remove_amount_from_account_balance

  enum :transaction_type, { debit: 0, credit: 1 }, default: :debit

  validates :transaction_at, presence: { message: "must have date of transaction" } 

  scope :open_deposits, -> () { where(cleared: false).where(transaction_type: :credit).order(transaction_at: :desc) }

  # after_save do
  #   new_balance = credit? ? bank_account.balance + amount : bank_account.balance - amount
  #   bank_account.update_balance!(new_balance)
  # end

  # after_find do |check|
  #   check.orginal_amount = check.amount
  # end

  private

    def update_bank_account_balance
      if orginal_amount.present? && orginal_amount != amount
        balance = bank_account.balance + (credit? ? -orginal_amount : orginal_amount)
      else
        balance = bank_account.balance
      end
      new_balance = balance + (credit? ? amount : -amount)
      bank_account.update_balance!(new_balance)
    end

    def set_orginal_amount
      self.orginal_amount ||= amount
    end

    def remove_amount_from_account_balance
      new_balance = bank_account.balance + (credit? ? -amount : amount)
      bank_account.update_balance!(new_balance)
    end
end