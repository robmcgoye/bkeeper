class ReconciliationItem < ApplicationRecord
  belongs_to :reconciliation
  belongs_to :register
end
