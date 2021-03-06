from flask import Flask
from peewee import *
from playhouse.db_url import connect
import datetime

database_connection = MySQLDatabase(
    'aaronmillet$twitter',
    host='aaronmillet.mysql.pythonanywhere-services.com',
    port=3306,
    user='aaronmillet',
    passwd='databases')

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
        database = database_connection

class Users(BaseModel):
    id = IntegerField(unique=True, primary_key=True)
    name = CharField()

    class Meta:
        order_by = ('id',)

class Tweets(BaseModel):
    tweet_id = IntegerField(unique=True, primary_key=True)
    author = ForeignKeyField(Users, related_name='tweets-users')
    message = CharField()
    date = DateTimeField(default=datetime.datetime.now)
    num_favorites = IntegerField()
    num_retweets = IntegerField()

    class Meta:
        order_by = ('tweet_id',)

# class Retweets(BaseModel):
#     tweet_id = ForeignKeyField(Tweets, related_name='retweets-tweets')
#     user_id = ForeignKeyField(Users, related_name='retweets-users')
#     date = DateTimeField(default=datetime.datetime.now)

#     class Meta:
#         primary_key = CompositeKey('tweet_id', 'user_id')

# class Favorites(BaseModel):
#     tweet_id = ForeignKeyField(Tweets, related_name='favorites-tweets')
#     user_id = ForeignKeyField(Users, related_name='favorited-users')
#     date = DateTimeField(default=datetime.datetime.now)

#     class Meta:
#         primary_key = CompositeKey('tweet_id', 'user_id')

# class Following(BaseModel):
#     following_id = ForeignKeyField(Users, related_name='following-users')
#     follower_id = ForeignKeyField(Users, related_name='follower-users')
#     date = DateTimeField(default=datetime.datetime.now)

#     class Meta:
#         primary_key = CompositeKey('following_id', 'follower_id')




def tweet(user_id, message):
    new_tweet = Tweets.create(
        author = user_id, 
        message = message,
        num_retweets = 0,
        num_favorites = 0 )
    new_tweet.save()

def retweet(tweet_id, user_id):
    pass

def delete_tweet(tweet_id):
    pass

def favorite_tweet(tweet_id, user_id):
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
