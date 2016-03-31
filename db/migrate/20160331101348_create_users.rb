class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :geo
      # For simplicity, we can afford it now.
      # Otherwise we can use paperclip if we don't like binary in db.
      t.binary :picture

      t.timestamps null: false
    end
  end
end
