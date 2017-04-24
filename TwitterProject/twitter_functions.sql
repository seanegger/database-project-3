/*
	Database and table creation
*/
DROP DATABASE twitter;
CREATE DATABASE twitter;
use Twitter;
CREATE TABLE Tweets(
	tweet_id int NOT NULL AUTO_INCREMENT,
    author int NOT NULL,
    message varchar(140) NOT NULL,
    date varchar(10),
    num_favorites int,
    num_retweets int,
    PRIMARY KEY(tweet_id),
    FOREIGN KEY(author) REFERENCES Users(id)
);
CREATE TABLE Users(
	id int NOT NULL AUTO_INCREMENT,
    name varchar(100),
    PRIMARY KEY(id)
);
CREATE TABLE Favorites(
	tweet_id int NOT NULL,
    user_id int NOT NULL,
    date datetime,
    PRIMARY KEY(tweet_id, user_id),
    FOREIGN KEY(tweet_id) REFERENCES Tweets(tweet_id),
    FOREIGN KEY(user_id) REFERENCES Users(id)
);
CREATE TABLE Following(
	follower_id int NOT NULL,
    following_id int NOT NULL,
    date datetime,
    PRIMARY KEY(follower_id, following_id),
    FOREIGN KEY(follower_id) REFERENCES Users(id),
    FOREIGN KEY(following_id) REFERENCES Users(id)
);
CREATE TABLE Retweets(
	tweet_id int NOT NULL,
    user_id int NOT NULL,
    date datetime,
    PRIMARY KEY(tweet_id, user_id),
    FOREIGN KEY(tweet_id) REFERENCES Tweets(tweet_id),
    FOREIGN KEY(user_id) REFERENCES Users(id)
);

/*
	See Users Timeline
    This Query Runs 2 subqueries that 1) create a table of all tweets made by people the user follows
    and 2) create a table of all tweets that are retweeted by people the user follows
    These two results are unioned together and displayed with the retweet date included as retweet_date
*/
SELECT * FROM
#Retweet table
(SELECT Tweets.*, Retweets.user_id AS retweeter, Retweets.date AS retweet_date FROM Users JOIN Following
ON Users.id = Following.follower_id
AND Following.follower_id = THE_USER_WHOS_TIMELINE_YOU_WANT_TO_SEE
JOIN Retweets
ON Retweets.user_id = Following.following_id
JOIN Tweets
ON Retweets.tweet_id = Tweets.tweet_id) AS A
UNION
SELECT * FROM
#tweet table
(SELECT Tweets.*, NULL AS retweeter, NULL AS retweet_date FROM Users JOIN Following
ON Users.id = Following.follower_id
AND Following.follower_id = THE_USER_WHOS_TIMELINE_YOU_WANT_TO_SEE
JOIN Tweets
ON Tweets.author = Following.following_id) AS B
ORDER BY CASE
WHEN retweet_date IS NOT NULL THEN retweet_date
ELSE date
END DESC;

/*
	Tweet
    Insert a new Tweet into the Tweet table.
*/
INSERT INTO Tweets VALUES
	(DEFAULT, USER_ID, THE_MESSAGE, curdate(), 0, 0)

/*
	Retweet
    Inserts the retweeters id, the tweet id and the current date into
    the retweets table then updates the number of times the tweet has
    been retweeted
*/
INSERT INTO Retweets VALUES
(the_tweet_id, the_user_id, curdate());
UPDATE Tweets SET
num_retweets = num_retweets + 1
WHERE tweet_id = the_tweet_id;

/*
	Delete Tweet
    Deletes a tweet by removing from the tweet table and
    Removing any references in the Favorites table or the
    Retweets table
*/
DELETE FROM Tweets
WHERE tweet_id = the_id_of_the_tweet_to_delete;
DELETE FROM Retweets
WHERE tweet_id = the_id_of_the_tweet_to_delete;
DELETE FROM Favorites
WHERE tweet_id = the_id_of_the_tweet_to_delete;

/*
	Favorite a Tweet
    Updates the number of times the tweet has been favorited in
    the tweets table then inserts into the Favorites table the
    tweets id, the users name, and the current date
*/
UPDATE Tweets SET
num_favorites = num_favorites + 1
WHERE tweet_id = the_tweets_id;
INSERT INTO Favorites VALUES
(tweet_id, user_id, curdate());

/*
	Unfavorite a Tweet
    Decrements num_favorites if it can be decremented
    then removes favorite from favorite table
*/
UPDATE Tweets SET
num_favorites = num_favorites - 1
WHERE tweet_id = the_tweets_id
AND num_favorites >= 1;
DELETE FROM Favorites
WHERE tweet_id = the_tweet_id
AND user_id = the_user_id;


/*
	How many favorites does a Tweet have
    Checks the value in the tweets table for that tweet
*/
SELECT num_favorites FROM Tweets
WHERE tweet_id = the_tweet_id;

/*
	List Favorited Tweets
    Gets all the tweet data from a join of Tweets and
    Favourites where the user id on the favorites table is
    equal to the user in question
*/
SELECT Tweets.* FROM Favorites JOIN Tweets
WHERE Favorites.tweet_id = Tweets.tweed_id
AND Favorites.user_id = the_user_in_question;

/*
	Follow Another User
    Insert into the Following table the user id, the id of the user
    they want to follow, and the current date
*/
INSERT INTO Following VALUES
(the_users_id, the_id_of_the_user_they_want_to_follow, curdate());

/*
	Unfollow a User
    Deletes the row from following where the
    id of the person being followed = the id of the user they want to unfollow
    and the id of the follower = the user id
*/
DELETE FROM Following
WHERE follower_id = the_users_id
AND following_id = the_id_of_the_user_they_want_to_unfollow;

/*
	See how many followers a user has
	Counts in the Following table how many times the
    users id shows up as the id of the person being followed
    
*/
SELECT COUNT(following_id) FROM Following
WHERE following_id = id_of_user_in_question;

/*
	See how many people a user is following
    Counts in the Following table how many times the
    users id shows up as the id of the follower
*/
SELECT COUNT(follower_id) FROM Following
WHERE follower_id = id_of_user_in_question;

/*
	See a list of people a user is following
    Joins the User table with the following table where
    the follower is the user in question and the id of the
    person being followed mateches the id in the user table
    to get the name of the person being followed from the user table
*/
SELECT * FROM Users JOIN Following
WHERE Users.id = Following.following_id
AND Following.follower_id = the_id_of_the_user_in_question;

/*
	Get number of times a tweet has been retweeted
    Gets the number of retweets from the Tweets table
*/
SELECT num_retweets FROM Tweets
WHERE tweet_id = the_tweet_id;

