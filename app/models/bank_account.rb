class BankAccount < ApplicationRecord
  belongs_to :foundation

  validates :full_name, presence: true, uniqueness: { scope: :foundation_id }
end
