class Commitment < ApplicationRecord
  belongs_to :organization
  has_many :grants, dependent: :destroy
  monetize :amount_cents, numericality:  { greater_than: 0 }

  scope :organization_commitments, -> (organization_ids) { where(organization_id: organization_ids) }

  validates :code, :start_at, :end_at, presence: true
  validates :start_at, comparison: { less_than: :end_at }
  validates :number_payments, numericality: { greater_than: 0, only_integer: true }

end