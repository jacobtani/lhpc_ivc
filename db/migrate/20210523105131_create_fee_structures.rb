class CreateFeeStructures < ActiveRecord::Migration[6.1]
  def change
    create_table :fee_structures do |t|
      t.decimal :base_member_donation, default: 0.0
      t.decimal :cleaning_donation, default: 0.0
      t.boolean :caregiver_fees, default: false
      t.boolean :multiple_enrolled_days, default: false
      t.date :deleted_at
      t.timestamps
    end
  end
end
