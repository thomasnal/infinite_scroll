class FeedsController < ApplicationController
  def index
    uid = params[:id]
    page = params.fetch(:page, 1)
    per_page = params.fetch(:per_page, FeedItem::PER_PAGE)
    # Use prev_feed to improve infinite scroll list feature
    prev_feed = params.fetch(:prev_feed, nil)
    prev_feed = FeedItem.find(prev_feed) unless prev_feed.nil?

    u = User.find(uid) unless uid.nil?
    @feeds = u.feeds(page: page,
                     per_page: per_page,
                     prev_feed: prev_feed) unless u.nil?
  end
end
