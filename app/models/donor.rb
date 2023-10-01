class Donor < ApplicationRecord
  belongs_to :foundation
  has_many :contributions
  # , dependent: :destroy

  validates :full_name, presence: true, uniqueness: { scope: :foundation_id }
  validates :code , presence: :true, 
            length: { minimum: 2, maximum: 3 }, 
            uniqueness: { scope: :foundation_id } 

  scope :sort_full_name_up, -> { order(:full_name) } 
end