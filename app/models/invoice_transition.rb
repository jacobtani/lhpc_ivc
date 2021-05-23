class InvoiceTransition < ApplicationRecord
  belongs_to :invoice, inverse_of: :invoice_transitions
  validates :to_state, inclusion: { in: OrderStateMachine.states }

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = invoice.invoice_transitions.order(:sort_key).last
    return unless last_transition.present?

    last_transition.update_column(:most_recent, true)
  end
end
