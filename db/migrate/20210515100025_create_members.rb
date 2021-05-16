class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.integer :parent_id
      t.string :family_id, null: false
      t.string :first_name
      t.string :surname
      t.date :dob
      t.date :date_joined
      t.date :date_left
      t.string :email
      t.string :mobile
      t.string :address
      t.date :first_aid_expiry
      t.string :duty_day
      t.boolean :staff
      t.boolean :life_member
      t.boolean :has_caregiver, default: false    
      t.timestamps
    end
  end
end
