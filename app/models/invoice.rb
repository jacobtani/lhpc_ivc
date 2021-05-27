class Invoice < ApplicationRecord
  belongs_to :member
  # has_one_attached :attachment
  # before_save :analyze_attachment
  has_many :invoice_transitions, class_name: 'InvoiceTransition', autosave: false, dependent: :destroy

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: InvoiceTransition,
    initial_state: :unpaid
  ]

  def state_machine
    @state_machine ||= InvoiceStateMachine.new(self, transition_class: InvoiceTransition)
  end

  def small_image_url
    attachment.variant(resize: '200x113').processed
  end

  def medium_image_url
    attachment.variant(resize: '1024x576').processed
  end

  # Extracts informations like image dimensions and saves them in blob metadata.
  def analyze_attachment
    if self.attachment
      self.attachment.analyze
    end
  end
end
