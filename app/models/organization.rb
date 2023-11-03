class Organization < ApplicationRecord
  belongs_to :foundation
  belongs_to :organization_type
  has_many :commitments, dependent: :destroy
  has_many :contributions
  # , dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :foundation_id }
  
  before_destroy :validate_before_destroy

  scope :sort_name_up, -> { order(:name) }
  scope :sort_name_down, -> { order(name: :desc) }
  scope :sort_contact_down, -> { order(contact: :desc) }
  scope :sort_contact_up, -> { order(:contact) }
  scope :filter_by_name, -> (query) { where("name LIKE ?", "%#{sanitize_sql_like(query)}%") }

  scope :sort_type_up, -> { includes(:organization_type).order("organization_types.code") }
  scope :sort_type_down, -> { includes(:organization_type).order("organization_types.code desc") }

  private

    def validate_before_destroy
      if contributions.cleared_contributions.size > 0 
        errors.add(:base, "Cannot delete this organization because it has cleared contributions!")
        throw(:abort)
      else
        contributions.destroy_all
      end    
    end
    
end