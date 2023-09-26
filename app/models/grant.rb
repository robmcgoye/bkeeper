class Grant < ApplicationRecord
  belongs_to :organization
  belongs_to :register
  belongs_to :donor
  belongs_to :funding_source
  belongs_to :commitment, optional: true

  accepts_nested_attributes_for :register
  
  scope :foundation_grants, -> (organization_ids) { where(organization_id: organization_ids) }

end