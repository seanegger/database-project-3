INSERT INTO Retweets VALUES
(the_tweet_id, the_user_id);
UPDATE Tweets SET
num_retweets = num_retweets + 1
WHERE tweet_id = the_tweet_id;

