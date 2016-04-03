class FeedsController < ApplicationController
  def index
    uid = params[:id]
    fid = params.fetch(:prev_feed_id, nil)
    page = params.fetch(:page, nil)
    per_page = params.fetch(:per_page, FeedItem::PER_PAGE)

    user = User.find(uid) unless uid.nil?
    feed = FeedItem.find(fid) unless fid.nil?

    @feeds= []
    @feeds = user.feeds.newest_first.page(
      num: page,
      after_feed: (feed.nil? ? nil : feed),
      per_page: per_page) unless user.nil?
  end
end
