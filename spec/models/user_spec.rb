require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :all

  it "must return feeds belonging to the user" do
    feeds = users(:joe).feeds

    expect(feeds.length).to eq FeedItem.where(:user => users(:joe)).count
  end
end
