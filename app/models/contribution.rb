class Contribution < ApplicationRecord
  belongs_to :organization
  belongs_to :check
  # has_one :check
  belongs_to :donor
  belongs_to :funding_source
  belongs_to :commitment, optional: true

  validate :prevent_edits_when_cleared
  validate :check_commitment_total

  after_save :check_if_commitment_completed
  before_destroy :validate_before_destroy
  after_destroy :remove_check
  
  monetize :non_deductible_cents
  accepts_nested_attributes_for :check
  
  enum :in_kind, { na: 0, househld_effects: 1, personal_effects: 2, securities: 3 }, default: :na
  
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

  def self.graph_contributions
    # contributions = self.select('checks.amount_cents, organizations.name, checks.transaction_at')
    contributions = self.select('SUM(checks.amount_cents) AS total, checks.transaction_at')
          .joins(:check).joins(:organization)
          .where('checks.transaction_at >= ? AND checks.transaction_at <= ?', 3.month.ago, Time.current)
          .group('checks.transaction_at')
          .order('checks.transaction_at DESC')
          formated_contributions = contributions.pluck('checks.transaction_at as date', 'SUM(checks.amount_cents) as total')
          # formated_contributions = contributions.pluck( 'checks.transaction_at as date', 'organizations.name as name', 'checks.amount_cents as total')
          # formated_contributions.map! {|item| [ item[0], item[1], Money.from_cents(item[2]).format(symbol: nil) ]}
          formated_contributions.map! {|item| [ item[0], Money.from_cents(item[1]).format(symbol: nil) ]}
        end

  private

    def check_if_commitment_completed
      if commitment_id.present? && commitment.amount_due == 0
        commitment.update(completed: true)
      end
    end

    def check_commitment_total
      if commitment_id.present? && (commitment.amount_due - check.amount_cents) < 0
        errors.add(:base, "Payment exceeds the commitment total") 
      end
    end

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
      if commitment_id.present? && commitment.completed && commitment.amount_due > 0
        commitment.update(completed: false)
      end
    end
end