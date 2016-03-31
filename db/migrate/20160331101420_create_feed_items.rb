class CreateFeedItems < ActiveRecord::Migration
  def change
    create_table :feed_items do |t|
      t.text :content

      t.timestamps null: false
    end

    add_index :feed_items, :created_at
  end
end
