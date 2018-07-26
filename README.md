## Description

This project implements infinitely scrolling list feature.

## Installation

    git clone http://github.com/thomasnal/infinite_scroll 

## Run tests

    bundle install
    rake db:setup
    rake spec

## Approach to implementation

Core functionality is provided by the `Paginable` module. It extends `FeedItem`
model to allow pagination of user feeds.

A naive and ideal approach is implemented.

The naive paging functionality is achieved by providing a page number as an
argument. Drawback of the naive approach is a time performance getting slower
as page sourgh increases.

The ideal approach is operate in a constant time performance independent of
the page number that is searched to ensure massive scalability.  This approach
is implemented by providing the last feed of the currenlty displayed page as
an argument.

## Performance

To see performance comparison of the two paging options, execute

    rake spec:perf_report

It builds a million record dataset and prints result of SQL EXPLAIN/ANALYZE
query for several different scenarios. (I suggest to re-run the task once
the system finishes writing cached data into database. Until that time, explain
analyze will be influenced by the writing operation.) See the output below.

### Performance Report

* page 1000
```
EXPLAIN ANALYZE SELECT  "feed_items".* FROM "feed_items" WHERE "feed_items"."user_id" = $1  ORDER BY "feed_items"."created_at" DESC LIMIT 20 OFFSET 19981 [["user_id", 1]]
                                                                                QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=1632.01..1633.65 rows=20 width=30) (actual time=13.357..13.372 rows=20 loops=1)
   ->  Index Scan Backward using index_feed_items_on_created_at on feed_items  (cost=0.42..81657.43 rows=1000000 width=30) (actual time=0.030..11.895 rows=20001 loops=1)
         Filter: (user_id = 1)
 Planning time: 0.172 ms
 Execution time: 13.421 ms
 (5 rows)
```

* page 10000
```
EXPLAIN ANALYZE SELECT  "feed_items".* FROM "feed_items" WHERE "feed_items"."user_id" = $1  ORDER BY "feed_items"."created_at" DESC LIMIT 20 OFFSET 199981 [["user_id", 1]]
                                                                                 QUERY PLAN
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=16330.27..16331.91 rows=20 width=30) (actual time=130.085..130.099 rows=20 loops=1)
   ->  Index Scan Backward using index_feed_items_on_created_at on feed_items  (cost=0.42..81657.43 rows=1000000 width=30) (actual time=0.026..115.906 rows=200001 loops=1)
         Filter: (user_id = 1)
 Planning time: 0.205 ms
 Execution time: 130.141 ms
 (5 rows)
```

* page 25000
```
EXPLAIN ANALYZE SELECT  "feed_items".* FROM "feed_items" WHERE "feed_items"."user_id" = $1  ORDER BY "feed_items"."created_at" DESC LIMIT 20 OFFSET 499981 [["user_id", 1]]
                                                                                 QUERY PLAN
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=40827.37..40829.01 rows=20 width=30) (actual time=332.652..332.665 rows=20 loops=1)
   ->  Index Scan Backward using index_feed_items_on_created_at on feed_items  (cost=0.42..81657.43 rows=1000000 width=30) (actual time=0.025..296.365 rows=500001 loops=1)
         Filter: (user_id = 1)
 Planning time: 0.164 ms
 Execution time: 332.702 ms
 (5 rows)
```

* page 25000 using after feed
```
EXPLAIN ANALYZE SELECT  "feed_items".* FROM "feed_items" WHERE "feed_items"."user_id" = $1 AND (created_at < '2016-04-03 09:35:04.500019')  ORDER BY "feed_items"."created_at" DESC LIMIT 20 [["user_id", 1]]
                                                                             QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=0.42..2.11 rows=20 width=30) (actual time=0.032..0.045 rows=20 loops=1)
   ->  Index Scan Backward using index_feed_items_on_created_at on feed_items  (cost=0.42..42462.49 rows=504503 width=30) (actual time=0.031..0.041 rows=20 loops=1)
         Index Cond: (created_at < '2016-04-03 09:35:04.500019'::timestamp without time zone)
         Filter: (user_id = 1)
 Planning time: 0.157 ms
 Execution time: 0.093 ms
 (6 rows)
```
