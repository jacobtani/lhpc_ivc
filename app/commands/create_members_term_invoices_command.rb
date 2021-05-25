class CreateMembersTermInvoicesCommand
  attr_reader :member_donation,  :cleaning_donation

  def initialize(params:)
    @params = params
    @investment_option_returns = []
  end

  def call
    members.each do
      build_invoice_details_for_member
      create_invoice_record
      generate_invoice
      email_invoice
    end
  end

  private

  def create_member_term_invoice
    member_donation, cleaning_donation = calculate_fees_for_member(member)
    invoice = create_invoice_record("INV-#{SecureRandom.uuid}", member_donation, cleaning_donation, member)
    generated_invoice = build_pdf_invoice(invoice)
    email_invoice(generated_invoice)
  end

  def calculate_fees_for_member(member)
    fee_calculator_results = FeeCalculator.new(member: member).call
    @member_donation = fee_calculator_results.member_donation
    @cleaning_donation = fee_calculator_results.cleaning_donation
  end

  def create_invoice_record(invoice_number, member_donation, cleaning_donation, member)
    Invoice.create!(invoice_number: invoice_number, invoice_date: Date.current, due_date: Date.current.end_of_month + 20.days, member_donation: member_donation, cleaning_donation: cleaning_donation, additional_charges: additional_charges, member_id: member.id)
  end

  def build_pdf_invoice(invoice)
    InvoiceGenerator.new(invoice: invoice, term_number: @params[:term_number], year: @params[:year]).call
  end

  def email_invoice(pdf_invoice)
  end

  def members
    @members ||= Member.active.children
  end
end
