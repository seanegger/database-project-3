DELETE FROM Following
WHERE follower_id = the_users_id
AND following_id = the_id_of_the_user_they_want_to_unfollow;