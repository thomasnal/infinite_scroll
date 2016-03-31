class AddUserIdToFeedItems < ActiveRecord::Migration
  def change
    add_column :feed_items, :user_id, :integer
    add_index :feed_items, :user_id
  end
end
