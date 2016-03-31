require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :all

  it "must return feeds" do
    f = users(:joe).feeds
    
    per_page = FeedItem::PER_PAGE
    expect(f.count).to eq per_page
    1.upto(per_page) do |i|
      expect(f[i-1].content).to eq i.to_s
    end
  end

  it "must return paged feeds" do
    page = 2
    f = users(:joe).feeds page: page
    
    per_page = FeedItem::PER_PAGE
    expect(f.count).to eq per_page
    1.upto(per_page) do |i|
      expect(f[i-1].content).to eq ((page-1)*per_page + i).to_s
    end
  end

  it "must return paged feeds with custom per_page" do
    per_page = 10
    page = 2
    f = users(:joe).feeds page: page, per_page: per_page
    
    expect(f.count).to eq per_page
    1.upto(per_page) do |i|
      expect(f[i-1].content).to eq ((page-1)*per_page + i).to_s
    end
  end

  it "must return paged feeds from prev feed" do
    pos = 50
    prev_feed = users(:joe).feeds(per_page: 100)[pos-1]

    # excpected to get feeds starting with '51'
    f = users(:joe).feeds prev_feed: prev_feed

    per_page = FeedItem::PER_PAGE
    expect(f.count).to eq per_page
    1.upto(per_page) do |i|
      expect(f[i-1].content).to eq (pos + i).to_s
    end
  end

  it "must return empty list if page is over boundary" do
    f = users(:joe).feeds page: 456, per_page: 10
    
    expect(f).to be_empty
  end

  it "must return all feeds if per_page is over boundary" do
    per_page = 456
    f = users(:joe).feeds page: 1, per_page: per_page
    
    expect(f.count).to eq FeedItem.where(:user => users(:joe)).count
  end
end
