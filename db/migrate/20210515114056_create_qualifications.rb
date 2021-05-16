class CreateQualifications < ActiveRecord::Migration[6.1]
  def change
    create_table :qualifications do |t|
      t.string :name
      t.decimal :discount_amount
      t.timestamps
    end
  end
end
