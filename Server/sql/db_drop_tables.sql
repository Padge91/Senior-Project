--this sql will drop all tables (essentially reset database to clean slate)
drop table users cascade;
drop table items cascade;
drop table genres cascade;
drop table comments cascade;
drop table comment_parents cascade;
drop table comment_ratings cascade;
drop table libraries cascade;
drop table library_items cascade;
drop table item_statistics cascade;
drop table item_images cascade;
drop table item_genres cascade;
drop table item_reviews cascade;
drop table item_comments cascade;
drop table user_ignored_items cascade;
drop table user_sessions cascade;
drop table user_friends cascade;
drop table user_parental_controls cascade;
