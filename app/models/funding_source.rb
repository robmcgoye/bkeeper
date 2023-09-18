class FundingSource < ApplicationRecord
  belongs_to :foundation

  validates :full_name, presence: true
  validates :short_name , presence: :true, length: { minimum: 2, maximum: 12 } 
  validates :code , presence: :true, 
            length: { minimum: 2, maximum: 8 }, 
            uniqueness: { scope: :foundation_id } 

end
