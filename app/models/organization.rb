class Organization < ApplicationRecord
  belongs_to :foundation
  belongs_to :organization_type

  validates :name, presence: true, uniqueness: { scope: :foundation_id }
  

end