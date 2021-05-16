class Member < ApplicationRecord
  has_many :children, class_name: "Member", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Member", optional: true
  has_many :qualifications
  has_many :invoices, dependent: :destroy
  scope :active, -> { where(date_left: nil) }
  scope :adult, -> { where(parent_id: nil) }
  scope :children, -> { where.not(parent_id: nil) }

  def parent_children
    Member.where(parent_id: self.id)
  end
end
