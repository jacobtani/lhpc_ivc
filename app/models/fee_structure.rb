class FeeStructure < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }
end
