class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.date :invoice_date
      t.date :due_date
      t.date :payment_date
      t.decimal :member_donation, default: 0.0
      t.decimal :cleaning_donation, default: 0.0
      t.decimal :payment_received, default: 0.0
      t.references :member
      t.timestamps
    end
  end
end
