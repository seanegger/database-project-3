DELETE FROM Tweets
WHERE tweet_id = the_id_of_the_tweet_to_delete;
DELETE FROM Retweets
WHERE tweet_id = the_id_of_the_tweet_to_delete;
DELETE FROM Favorites
WHERE tweet_id = the_id_of_the_tweet_to_delete;