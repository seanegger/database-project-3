UPDATE Tweets SET
num_favorites = num_favorites + 1
WHERE tweet_id = the_tweets_id;
INSERT INTO Favorites VALUES
(tweet_id, user_id, curdate());
