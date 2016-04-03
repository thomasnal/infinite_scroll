joe = User.find_or_create_by :id => 1 do |u|
  u.name = 'Joe'
  u.geo = 'London'
  u.picture = nil
end

# To test performance on table with a million records we have to fabricate
# the records and their created_at column value.
#
# Using Time.now - i/1000000 to keep record '1' the newest record spread
# the records over 1 second.

time = Time.now.to_i
insert_query = <<-SQL
  INSERT INTO feed_items
    (content, created_at, updated_at, user_id)
  SELECT
    i,
    to_timestamp(#{time} - i::float/1000000),
    to_timestamp(#{time} - i::float/1000000),
    #{joe.id}
  FROM
    generate_series(1,1000000) AS i;
SQL

puts 'Generating dataset of a million records...'
result = ActiveRecord::Base.connection.execute insert_query
puts "Failed" if result.nil?
