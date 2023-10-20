class Contribution < ApplicationRecord
  belongs_to :organization
  belongs_to :check
  belongs_to :donor
  belongs_to :funding_source
  belongs_to :commitment, optional: true

  monetize :non_deductible_cents
  accepts_nested_attributes_for :check
  
  enum :in_kind, { na: 0, househld_effects: 1, personal_effects: 2, securities: 3 }, default: :na

  scope :organization_contributions, -> (organization_ids) { where(organization_id: organization_ids) }
  scope :sort_date_up, -> { includes(:check).order("checks.transaction_at") }
  scope :sort_date_down, -> { includes(:check).order("checks.transaction_at desc") }
  scope :sort_check_num_up, -> { includes(:check).order("checks.check_number") }
  scope :sort_check_num_down, -> { includes(:check).order("checks.check_number desc") }
  scope :sort_amt_up, -> { includes(:check).order("checks.amount_cents") }
  scope :sort_amt_down, -> { includes(:check).order("checks.amount_cents desc") }
  scope :sort_organization_up, -> { includes(:check).order("organizations.name") }
  scope :sort_organization_down, -> { includes(:check).order("organizations.name desc") }

end