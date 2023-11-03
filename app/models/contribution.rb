class Contribution < ApplicationRecord
  belongs_to :organization
  belongs_to :check
  # has_one :check
  belongs_to :donor
  belongs_to :funding_source
  belongs_to :commitment, optional: true

  before_destroy :validate_before_destroy
  after_destroy :remove_check
  
  monetize :non_deductible_cents
  accepts_nested_attributes_for :check
  
  enum :in_kind, { na: 0, househld_effects: 1, personal_effects: 2, securities: 3 }, default: :na
  
  validate :prevent_edits_when_cleared

  scope :organization_contributions, -> (organization_ids) { where(organization_id: organization_ids) }
  scope :cleared_contributions, ->() { joins(:check).where( "checks.cleared = true" ) }
  scope :open_contributions, ->() { joins(:check).where( "checks.cleared = false" ) }
  scope :sort_date_up, -> { includes(:check).order("checks.transaction_at") }
  scope :sort_date_down, -> { includes(:check).order("checks.transaction_at desc") }
  scope :sort_check_num_up, -> { includes(:check).order("checks.check_number") }
  scope :sort_check_num_down, -> { includes(:check).order("checks.check_number desc") }
  scope :sort_amt_up, -> { includes(:check).order("checks.amount_cents") }
  scope :sort_amt_down, -> { includes(:check).order("checks.amount_cents desc") }
  scope :sort_organization_up, -> { includes(:organization).order("organizations.name") }
  scope :sort_organization_down, -> { includes(:organization).order("organizations.name desc") }

  private

    def prevent_edits_when_cleared
      if check.cleared?
        errors.add(:base, "Cannot make changes after it is cleared")
      end
    end

    def validate_before_destroy
      if check.cleared?
        errors.add(:base, "Cannot delete this contribution because it has already been cleared!")
        throw(:abort)
      end
    end

    def remove_check
      check.destroy
    end
end