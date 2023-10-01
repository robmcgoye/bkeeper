class Foundation < ApplicationRecord
  
  has_many :bank_accounts, dependent: :destroy
  has_many :donors, dependent: :destroy
  has_many :funding_sources, dependent: :destroy
  has_many :organizations, dependent: :destroy
  has_many :organization_types, dependent: :destroy

  validates :short_name, presence: true, length: { maximum: 4 }
  validates :long_name, presence: true, uniqueness: true

end
