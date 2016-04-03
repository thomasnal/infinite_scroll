class FeedItem < ActiveRecord::Base
  belongs_to :user

  include Paginable

  # Ordering by created_at is good enough for practical use, no need for
  # additional ordering by id. Resolution of the timestamp is in milliseconds
  # therefore no two feeds of the same user are expected to be created in
  # the same millisecond.

  scope :newest_first, ->{ order created_at: :desc }
end
