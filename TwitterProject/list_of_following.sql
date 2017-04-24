SELECT * FROM Users JOIN Following
WHERE Users.id = Following.following_id
AND Following.follower_id = the_id_of_the_user_in_question;