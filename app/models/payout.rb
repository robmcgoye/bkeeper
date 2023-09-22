class Payout < ApplicationRecord
  belongs_to :commitment
  belongs_to :grant
end