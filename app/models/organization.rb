class Organization < ApplicationRecord
  belongs_to :foundation
  belongs_to :organization_type
  has_many :commitments, dependent: :destroy
  has_many :grants, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :foundation_id }
  
  scope :sort_name_up, -> { order(:name) }
  scope :sort_name_down, -> { order(name: :desc) }

end