class BankAccount < ApplicationRecord
  belongs_to :foundation
  has_many :reconciliations, dependent: :destroy
  has_many :registers, dependent: :destroy
  
  monetize :starting_balance_cents, numericality: { greater_than: 0 }
  monetize :balance_cents

  validates :full_name, presence: true, uniqueness: { scope: :foundation_id }

  scope :foundation_accounts, -> (foundation_id) { where(foundation_id: foundation_id) }
  
  before_save if: :primary do
    BankAccount.foundation_accounts(foundation_id).update_all(primary: false) 
  end

  after_create do
    Register.create!(
      transaction_at: Time.new,
      transaction_type: :credit,
      description: "Starting Balance",
      bank_account_id: id,
      amount: starting_balance
    )
  end

  def update_balance!(new_balance)
    update(balance: new_balance)
  end

end
