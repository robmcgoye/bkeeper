class Foundation < ApplicationRecord
  validates :short_name, presence: true, length: { maximum: 4 }
  validates :long_name, presence: true, uniqueness: true
end
