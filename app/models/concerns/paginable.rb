module Paginable
  extend ActiveSupport::Concern

  included do
    PER_PAGE = 20

    # Higher the offset slower the query response time. The industry workaround
    # is to supplement previously found feed item.
    # This is particularly used in infinite scroll lists when forward seeking
    # is used.

    # As a feature the after_feed can be combined with page number.
 
    scope :page, ->(num: nil, after_feed: nil, per_page: PER_PAGE) do
      rel = self

      rel = rel.offset((num-1) * per_page) if num.present?
      if after_feed.present? && after_feed.is_a?(FeedItem)
        rel = rel.where("created_at < ?", after_feed.created_at)
      end
      rel = rel.limit(per_page)
    end
  end
end
