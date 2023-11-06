class Donor < ApplicationRecord
  belongs_to :foundation
  has_many :contributions
  # , dependent: :destroy

  validates :full_name, presence: true, uniqueness: { scope: :foundation_id }
  validates :code , presence: :true, 
            length: { minimum: 2, maximum: 3 }, 
            uniqueness: { scope: :foundation_id } 

  scope :sort_full_name_up, -> { order(:full_name) } 

  def self.top_donors
    donors = self.select('donors.id, SUM(checks.amount_cents) as total_contributions, donors.full_name')
          .joins(contributions: :check)
          .where('checks.transaction_at >= ? AND checks.transaction_at <= ?', 3.month.ago, Time.current)
          .group('donors.id, donors.full_name')
          .order('total_contributions DESC')
          .limit(10)
    formated_donors = donors.pluck( :full_name, 'checks.amount_cents as total_contributions')
    formated_donors.map! {|item| [ item[0], Money.from_cents(item[1]).format(symbol: nil) ]}
  end

end