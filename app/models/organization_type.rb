class OrganizationType < ApplicationRecord
  belongs_to :foundation
  has_many :organizations

  validates :description, presence: true
  validates :code , presence: :true, 
            length: { minimum: 2, maximum: 3 }, 
            uniqueness: { scope: :foundation_id } 

end
