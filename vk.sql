DROP DATABASE IF EXISTS vk;
create database IF NOT exists vk;
use vk;

DROP TABLE IF EXISTS profiles;
DROP TABLE IF EXISTS users;


CREATE TABLE users (

     id SERIAL PRIMARY KEY, 
     firstname VARCHAR (100),
     lastname VARCHAR (100) COMMENT 'фамилия',
     emai VARCHAR (120) UNIQUE, 
     password_hash VARCHAR (100),
     phone BIGINT UNSIGNED ,
     IS_deleted BIT DEFAULT b'0',
    INDEX users_lastname_firstname_idx(lastname, firstname) 
    
     );
    
DROP TABLE IF EXISTS profiles;    
   
CREATE TABLE profiles (
    
   user_id SERIAL PRIMARY KEY, 
   gender CHAR(1),
   birthday DATE,
   photo_id BIGINT UNSIGNED, 
   music BIGINT UNSIGNED, 
   created_at DATETIME DEFAULT NOW() 
   ); 
  
  ALTER TABLE profiles ADD CONSTRAINT fk_user_id
  FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;
 
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY, 
	from_USER_id BIGINT UNSIGNED NOT NULL,
	to_USER_id BIGINT UNSIGNED NOT NULL,  
	body TEXT,
	created_at DATETIME,
	FOREIGN KEY (from_user_id) REFERENCES users (id)  ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (to_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);


DROP TABLE IF EXISTS fried_requests;
CREATE TABLE fried_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	`status` ENUM  ('requested', 'approved', 'declined', 'unfriended'),
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE NOW(),
	PRIMARY KEY (initiator_user_id, target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users (id)  ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (target_user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	
	id SERIAL PRIMARY KEY,
	name VARCHAR (150),
	INDEX communities_name_idx (name)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (

	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	
PRIMARY KEY (community_id, user_id),

FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (community_id) REFERENCES communities(id)

);


DROP TABLE IF EXISTS media;

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
id SERIAL PRIMARY KEY,
name VARCHAR(255)
);


DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_type_id BIGINT UNSIGNED,
	-- filename BLOB,
	filename VARCHAR(255),
	`size` INT,
	metadata JSON,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);


DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
media_id BIGINT UNSIGNED NOT NULL,
publisation_id BIGINT UNSIGNED NOT NULL,
created_at DATETIME DEFAULT NOW(),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_id) REFERENCES media(id)

);



DROP TABLE IF EXISTS `photo albums`;
DROP TABLE IF EXISTS photos;
DROP TABLE IF EXISTS `photo_albums`;


CREATE TABLE photo_albums (
	`id` SERIAL,
	`name` VARCHAR (255) DEFAULT NULL,
	`user_id` BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (user_id) REFERENCES users(id),
PRIMARY KEY (id)
);



DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
	id SERIAL PRIMARY KEY, 
	`album_id` BIGINT UNSIGNED NOT NULL,
	`media_id` BIGINT UNSIGNED NOT NULL,
	`created_at` DATETIME DEFAULT NOW(),
	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);


ALTER TABLE `profiles` ADD CONSTRAINT fk_photo_id
FOREIGN KEY (photo_id) REFERENCES photos(id) ON UPDATE CASCADE ON DELETE SET NULL;


DROP TABLE IF EXISTS `playlists`;
CREATE TABLE `playlists` (
	`playlist_id` SERIAL,
	`user_id` BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);





DROP TABLE IF EXISTS audiofiles;
CREATE TABLE audiofiles (
trek_id BIGINT UNSIGNED NOT NULL,
media_id BIGINT UNSIGNED NOT NULL,
name VARCHAR (255) NOT NULL,
playlist_id BIGINT UNSIGNED NOT NULL,
artist_id BIGINT UNSIGNED NOT NULL,
album_id BIGINT UNSIGNED NOT NULL,
jenre_id BIGINT UNSIGNED NOT NULL,
duration TIME,

PRIMARY KEY (trek_id, artist_id),

FOREIGN KEY (media_id) REFERENCES media(id),
FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id)
);



ALTER TABLE `profiles` ADD CONSTRAINT fk_music_id
FOREIGN KEY (music) REFERENCES audiofiles (trek_id) ON UPDATE CASCADE ON DELETE SET NULL;

DROP TABLE IF EXISTS Publication ; -- публикация на стене
CREATE TABLE Publication (
	id SERIAL PRIMARY KEY, 
	FROM_user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	media_id  BIGINT UNSIGNED,
	likes BIGINT UNSIGNED,
	created_at DATETIME,
	FOREIGN KEY (from_user_id) REFERENCES users (id), -- ON UPDATE CASCADE ON DELETE SET  NULL,
	FOREIGN KEY (media_id) REFERENCES media (id) ON UPDATE CASCADE ON DELETE SET NULL,
	FOREIGN KEY (likes) REFERENCES likes (id) ON UPDATE CASCADE ON DELETE CASCADE

);






 
 
   
  

 
  
   
    
 
    

