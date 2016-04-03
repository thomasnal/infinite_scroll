class User < ActiveRecord::Base
  has_many :feeds, :class_name => 'FeedItem', :dependent => :destroy
end
