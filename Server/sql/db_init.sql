--create database
create database EMBR;
--create user
create user 'db_user'@'localhost' identified by 'group2isthebest1!';
GRANT ALL PRIVILEGES ON * . * TO 'db_user'@'localhost';
