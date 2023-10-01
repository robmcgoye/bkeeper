class Contribution < ApplicationRecord
  belongs_to :organization
  belongs_to :register
  belongs_to :donor
  belongs_to :funding_source
  belongs_to :commitment, optional: true

  monetize :non_deductible_cents
  accepts_nested_attributes_for :register
  
  enum :in_kind, { na: 0, househld_effects: 1, personal_effects: 2, securities: 3 }, default: :na

  scope :organization_contributions, -> (organization_ids) { where(organization_id: organization_ids) }

end