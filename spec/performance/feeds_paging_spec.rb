require 'rails_helper'

RSpec.describe 'Feeds paging performance', type: :performance,
  :perf_report => true do

  # Postgres driver for ActiveRecord calls EXPLAIN only.
  # Let's add ANALYZE to the call to display query execution and planning time.
  class ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
    def explain(arel, binds = [])
      sql = "EXPLAIN ANALYZE #{to_sql(arel, binds)}"
      ExplainPrettyPrinter.new.pp(exec_query(sql, 'EXPLAIN', binds))
    end
  end

  before(:all) do
    # If there is no user with id = 1 or if number of his feeds are less
    # than a million then load the dataset
    unless User.exists?(1) && User.find(1).feeds.count >= 1000000
      User.delete_all
      FeedItem.delete_all
      puts 'Loading data for generating performance report...'
      load Rails.root.join('db', 'performance_dataset.rb')
    else
      puts 'Using existing data for generating performance report...'
    end

    @user = User.find(1)
  end

  before do
    # This approach didn't perform reliable compared to the EXPLAIN ANALYZE
    # measurement. I rather believe the direct output of database system.
    # 
    # @sql_duration = 0
    # ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
    #   event = ActiveSupport::Notifications::Event.new(*args)
    #   @sql_duration = event.duration
    # end
  end

  it 'reports performance of getting page 1.000' do
    puts @user.feeds.newest_first.page(num: 1000).explain
    # puts 'SQL Execution Time: ' + @sql_duration.to_s
  end

  it 'reports performance of getting page 10.000' do
    puts @user.feeds.newest_first.page(num: 10000).explain
    # puts 'SQL Execution Time: ' + @sql_duration.to_s
  end

  it 'reports performance of getting page 25.000' do
    puts @user.feeds.newest_first.page(num: 25000).explain
    # puts 'SQL Execution Time: ' + @sql_duration.to_s
  end

  it 'reports performance of getting page 25.000 using after feed' do
    prev_feed = @user.feeds.newest_first.page(num: 24999).last
    puts @user.feeds.newest_first.page(after_feed: prev_feed).explain
    # puts 'SQL Execution Time: ' + @sql_duration.to_s
  end
end
