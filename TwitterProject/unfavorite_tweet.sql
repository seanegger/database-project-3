UPDATE Tweets SET
num_favorites = num_favorites - 1
WHERE tweet_id = the_tweets_id
AND num_favorites >= 1;
DELETE FROM Favorites
WHERE tweet_id = the_tweet_id
AND user_id = the_user_id;