SELECT tweets.* FROM Favorites JOIN Tweets
WHERE Favorites.tweet_id = Tweets.tweed_id
AND Favorites.user_id = the_user_in_question;