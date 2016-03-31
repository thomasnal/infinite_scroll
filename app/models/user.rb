class User < ActiveRecord::Base
  has_many :feed_items, :dependent => :destroy

  def feeds *args
    feed_items.newest_first *args
  end
end
