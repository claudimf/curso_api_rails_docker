class AddBirthdayToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :birthday, :date
  end
end
