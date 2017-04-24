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


    