class AddEnrolledDaysToMember < ActiveRecord::Migration[6.1]
  def change
    add_column :members, :enrolled_days, :string, default: [], array: true
  end
end
