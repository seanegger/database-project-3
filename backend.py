from flask import Flask
from peewee import *
# create a peewee database instance -- our models will use this database to 
# persist information
DATABASE_NAME = 'twitter'
database = MySQLDatabase(DATABASE_NAME)
app = Flask(__name__)

# This hook ensures that a connection is opened to handle any queries
# generted by the request
@app.before_request
def _db_connect():
    database.connect()


# This hook ensures that the connection is closed when weve finished
# processing the request
@app.teardown_request
def _db_close(exc):
    if not database.is_closed():
        database.close()

class BaseModel(Model):
    class Meta:
        database = database

class Users(BaseModel):
    id = IntegerField(unique=True, primary_key=True)
    name = CharField()

    class Meta:
        order_by = ('id',)

class Tweets(BaseModel):
    tweet_id = IntegerField(unique=True, primary_key=True)
    author = ForeignKeyField(Users, related_name='tweets-users')
    message = CharField()
    date = DateTimeField()
    num_favorites = IntegerField()
    num_retweets = IntegerField()

    class Meta:
        order_by = ('tweet_id',)

# class Retweets(BaseModel):
#     tweet_id = ForeignKeyField(Tweets, related_name='retweets-tweets')
#     user_id = ForeignKeyField(Users, related_name='retweets-users')
#     date = DateTimeField()

#     class Meta:
#         primary_key = CompositeKey('tweet_id', 'user_id')

# class Favorites(BaseModel):
#     tweet_id = ForeignKeyField(Tweets, related_name='favorites-tweets')
#     user_id = ForeignKeyField(Users, related_name='favorited-users')
#     date = DateTimeField()

#     class Meta:
#         primary_key = CompositeKey('tweet_id', 'user_id')

# class Following(BaseModel):
#     following_id = ForeignKeyField(Users, related_name='following-users')
#     follower_id = ForeignKeyField(Users, related_name='follower-users')
#     date = DateTimeField()

#     class Meta:
#         primary_key = CompositeKey('following_id', 'follower_id')




def tweet(user_id, message, date):
    new_tweet = Tweets(
        author = user_id, 
        message = date,
        num_retweets = 0,
        num_favorites = 0 )
    new_tweet.save()

def retweet(tweet_id, user_id, date):
    pass

def delete_tweet(tweet_id):
    pass

def favorite_tweet(tweet_id, user_id, date):
    pass

def unfavorite_tweet(tweet_id, user_id):
    pass

def how_many_favorites(tweet_id):
    pass

def list_favorited_tweets(user_id):
    pass

def follow_user(followed_id, follower_id):
    pass

def unfollow_user(followed_id, follower_id):
    pass

def how_many_followers(followed_id):
    pass

def how_many_followed(user_id):
    pass

def list_followed(user_id):
    pass

def get_num_retweets(tweet_id):
    pass


