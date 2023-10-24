class ReconciliationItem < ApplicationRecord
  belongs_to :reconciliation
  belongs_to :check

  after_save :clear_check

  private

    def clear_check
      Check.find(self.check_id).update(cleared: true)
    end

end
