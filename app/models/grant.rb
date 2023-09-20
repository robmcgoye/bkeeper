class Grant < ApplicationRecord
  belongs_to :organization
  belongs_to :register
  belongs_to :donor
  belongs_to :funding_source

end