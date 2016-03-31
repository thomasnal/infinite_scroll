class FeedItem < ActiveRecord::Base
  belongs_to :user

  PER_PAGE = 20

  # scopes
  def self.newest_first page: 1, per_page: PER_PAGE, prev_feed: nil
    # Ordering by created_at is good enough for practical use, no need for
    # additional ordering by id. Resolution of the timestamp is in milliseconds
    # therefore no two feeds of the same user are expected to be created in
    # the same millisecond.

    # Higher the offset slower the query response time. The industry workaround
    # is to supplement previously found feed item.
    # This is particularly used in infinite scroll lists when only forward
    # seeking is used.

    scoped = order(created_at: :desc)
    if prev_feed
      scoped = scoped.where("created_at < ?", prev_feed.created_at)
    else
      scoped = scoped.offset (page-1) * per_page
    end
    scoped = scoped.limit per_page
  end
end
