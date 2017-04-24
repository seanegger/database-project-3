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

INSERT INTO Users VALUES
	(DEFAULT, 'user1'),
	(DEFAULT,'user2'),
	(DEFAULT,'user3'),
	(DEFAULT,'user4');
INSERT INTO Tweets VALUES
	(DEFAULT, (SELECT id from Users WHERE Users.name = 'user1'),'this is the first tweet', curdate(), 0, 0),
    (DEFAULT, (SELECT id from Users WHERE Users.name = 'user2'),'this is the first tweet from user 2', curdate(), 0, 0),
    (DEFAULT, (SELECT id from Users WHERE Users.name = 'user2'),'this is the second tweet from user 2', curdate(), 0, 0),
    (DEFAULT, (SELECT id from Users WHERE Users.name = 'user3'),'this is the first tweet from user 3', curdate(), 0, 0),
    (DEFAULT, (SELECT id from Users WHERE Users.name = 'user4'),'this is the first tweet from user 4', '2017-04-14 00:00:00', 0, 0),
    (DEFAULT, (SELECT id from Users WHERE Users.name = 'user4'),'this is the second tweet from user 4', '2017-03-33 00:00:00', 0, 0),
	(DEFAULT, (SELECT id from Users WHERE Users.name = 'user4'),'this is the third tweet from user 4', '2017-03-32 00:00:00', 0, 0),
    (DEFAULT, (SELECT id from Users WHERE Users.name = 'user4'),'this is the fourth tweet from user 4', '2017-03-31 00:00:00', 0, 0);
#USER 1 Favorites User 2s first post
UPDATE Tweets SET 
num_favorites = num_favorites + 1
WHERE tweet_id = 2;
INSERT INTO Favorites VALUES
(2, 1, curdate());
#USER 1 Favorites User 2s Second Post
UPDATE Tweets SET
num_favorites = num_favorites + 1
WHERE tweet_id = 3;
INSERT INTO Favorites VALUES
(3, 1, curdate());
#User 1 Following User 4
INSERT INTO Following VALUES
(1, 4, curdate());
#USER 1 Retweets User 2s first post
INSERT INTO Retweets VALUES
(2, 1, curdate());
UPDATE Tweets SET
num_retweets = num_retweets + 1
WHERE tweet_id = 2;
#DELETE User 2s First Post
DELETE FROM Tweets
WHERE tweet_id = 2;
DELETE FROM Retweets
WHERE tweet_id = 2;
DELETE FROM Favorites
WHERE tweet_id = 2;
#USER 1 Unfavorites User 2s Second tweet
UPDATE Tweets SET
num_favorites = num_favorites - 1
WHERE tweet_id = 3
AND num_favorites >= 1;
DELETE FROM Favorites
WHERE tweet_id = 3
AND user_id = 1;
#User 1 Favorites User 4s 1st post
UPDATE Tweets SET
num_favorites = num_favorites + 1
WHERE tweet_id = 5;
INSERT INTO Favorites VALUES
(5, 1, curdate());
#Check How many times user 4s first tweet has been favorited
SELECT num_favorites FROM Tweets
WHERE tweet_id = 5;
#List User 1s Favorite Tweets
SELECT Tweets.* FROM Favorites JOIN Tweets
WHERE Favorites.tweet_id = Tweets.tweet_id
AND Favorites.user_id = 1;
#User 1 follows user 3
INSERT INTO Following VALUES
(1, 3, curdate());
#User 1 unfollows user 3
DELETE FROM Following
WHERE follower_id = 1
AND following_id = 3;
#Check folowers of user 4
SELECT COUNT(following_id) FROM Following
WHERE following_id = 4;
#Check how many people user 1 is following
SELECT COUNT(follower_id) FROM Following
WHERE follower_id = 1;
#Get list of people following user 4
SELECT * FROM Users JOIN Following
WHERE Users.id = Following.follower_id
AND Following.following_id = 4;
# User 1 Retweets User 4s second post
INSERT INTO Retweets VALUES
(7, 1, curdate());
UPDATE Tweets SET
num_retweets = num_retweets + 1
WHERE tweet_id = 7;
#User 4 retweets user 3
INSERT INTO Retweets VALUES
(4, 4, '2017-04-11 00:00:00');
UPDATE Tweets SET
num_retweets = num_retweets + 1
WHERE tweet_id = 4;
#Get number of times user 4s second post has been retweeted
SELECT num_retweets FROM Tweets
WHERE tweet_id = 7;
#Display Users 1 timeline
SELECT * FROM
#Retweet table
(SELECT Tweets.*, Retweets.user_id AS retweeter, Retweets.date AS retweet_date FROM Users JOIN Following
ON Users.id = Following.follower_id
AND Following.follower_id = 1
JOIN Retweets
ON Retweets.user_id = Following.following_id
JOIN Tweets
ON Retweets.tweet_id = Tweets.tweet_id) AS A
UNION
SELECT * FROM
#tweet table
(SELECT Tweets.*, NULL AS retweeter, NULL AS retweet_date FROM Users JOIN Following
ON Users.id = Following.follower_id
AND Following.follower_id = 1
JOIN Tweets
ON Tweets.author = Following.following_id) AS B
ORDER BY CASE
WHEN retweet_date IS NOT NULL THEN retweet_date
ELSE date
END DESC;




