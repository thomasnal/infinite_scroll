joe = User.create :id => 1, :name => 'Joe', :geo => 'London', :picture => nil

# To test performance on table with count lines 1million, we have to fabricate
# the records and their created_at column value.

insert_query = <<-SQL
insert into feed_items (content, created_at, updated_at, user_id) select x, cast(concat('2016-03-31 17:46:15.', cast(x as text)) as timestamp), cast(concat('2016-03-31 17:46:15.', cast(x as text)) as timestamp), 1 from generate_series(1,1000000) AS x;
SQL

result = ActiveRecord::Base.connection.execute(insert_query)
puts "Failed" if result.nil?

# Then we can test following two approaches.
# I would need more time to get them the benchmark case scripted and automated.
# Therefore I leave it in the comments for reference and provide the results
# in readme file.
#
# == offset approach
# explain analyze select content, created_at from feed_items where user_id=1 order by created_at DESC LIMIT 20 OFFSET 30000;
#
# == prev feed approach
# explain analyze select content, created_at from feed_items where user_id=1 AND created_at < '2016-03-031 17:46:15.730246' order by created_at DESC LIMIT 20; 

