require 'rails_helper'

RSpec.describe FeedItem, type: :model do
  fixtures :all

  it 'must return feeds ordered from newest to oldest' do
    feeds = FeedItem.where(:user => users(:joe)).newest_first

    # All feeds belonging to joe must be present
    expect(feeds.length).to eq FeedItem.where(:user => users(:joe)).count

    # A feed with higher index in the array must have created_at attribute
    # older than the previous one
    1.upto(feeds.length-1) do |i|
      expect(feeds[i-1].created_at).to be > feeds[i].created_at
    end
  end

  context "Paginable" do
    before do
      @all_feeds = FeedItem.where(:user => users(:joe)).order(created_at: :desc)
    end

    it 'must return the first page' do
      feeds = FeedItem
        .where(:user => users(:joe))
        .order(created_at: :desc)
        .page
 
      # assert number of returned feeds
      expect(feeds.length).to eq FeedItem::PER_PAGE

      # assert returned feeds. feeds must be those coming right after the 'feed'
      0.upto(feeds.length-1) do |i|
        expect(feeds[i]).to eq @all_feeds[i]
      end
    end

    it 'must return page after feed' do
      # take the last feed on the first page
      pos = FeedItem::PER_PAGE
      feed = @all_feeds[pos-1]
        
      # get the feeds page
      feeds = FeedItem
        .where(:user => users(:joe))
        .order(created_at: :desc)
        .page(after_feed: feed)

      # assert number of returned feeds
      expect(feeds.length).to eq FeedItem::PER_PAGE

      # assert returned feeds. feeds must be those coming right after the 'feed'
      0.upto(feeds.length-1) do |i|
        expect(feeds[i]).to eq @all_feeds[pos+i]
      end
    end

    it 'must return feeds on specific page number' do
      page_num = 2

      feeds = FeedItem
        .where(:user => users(:joe))
        .order(created_at: :desc)
        .page(num: page_num)

      # assert number of returned feeds
      per_page = FeedItem::PER_PAGE
      expect(feeds.length).to eq per_page

      # assert returned feeds. feeds must be those starting at position
      # per_page * page_num
      0.upto(feeds.length-1) do |i|
        expect(feeds[i]).to eq @all_feeds[(page_num-1) * per_page + i]
      end
    end

    it 'must return specific number of items' do
      # let's request 10 items per page and combine all the accepted parameters
      per_page = 10
      page_num = 2
      pos = 10
      feed = @all_feeds[pos-1]

      feeds = FeedItem
        .where(:user => users(:joe))
        .order(created_at: :desc)
        .page(num: page_num, after_feed: feed, per_page: per_page)
 
      # assert number of returned feeds
      expect(feeds.length).to eq per_page

      # assert returned feeds. feeds must be those starting at position
      # that is second page ((page_num-1) * per_page) after the 'feed' (pos)
      0.upto(feeds.length-1) do |i|
        expect(feeds[i]).to eq @all_feeds[pos + (page_num-1) * per_page + i]
      end
    end
  end
end
