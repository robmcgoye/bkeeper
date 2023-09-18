class Donor < ApplicationRecord
  belongs_to :foundation

  validates :full_name, presence: true, uniqueness: { scope: :foundation_id }
  validates :code , presence: :true, 
            length: { minimum: 2, maximum: 3 }, 
            uniqueness: { scope: :foundation_id } 
end