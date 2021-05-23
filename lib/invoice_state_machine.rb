class InvoiceStateMachine
  include Statesman::Machine

  state :unpaid, initial: true
  state :overdue
  state :paid
  state :waived

  transition from: :unpaid,                  to: %i[paid overdue waived]
  transition from: :overdue,                 to: %i[paid waived]
end
