--this file creates all tables with their appropriate types
--constraints are found in the other file
create table comments (
    id int not null,
    user_id int not null,
    create_date datetime not null,
    content text not null
);

create table comment_parents (
    id int not null,
    parent_id int not null,
    child_id int not null
);

create table comment_ratings (
    id int not null,
    user_id int not null,
    comment_id int not null,
    rating int not null
);

create table libraries (
    id int not null,
    user_id int not null,
    library_name varchar(30)
);

create table library_items (
    id int not null,
    library_id int not null,
    item_id int not null
);

create table genres (
    id int not null,
    name varchar(15)
);

create table Statistics (
    id int not null,
    item_id int not null,
    last_viewed datetime not null,
    views int not null
);

create table item_images (
    id int not null,
    item_id int not null,
    image blob not null
);

create table item_genres (
    id int not null,
    item_id int not null,
    genre_id int not null
);

create table item_reviews (
    id int not null,
    item_id int not null,
    user_id int not null,
    review_value int
);

create table item_comments (
    id int not null,
    item_id int not null,
    comment_id int not null
);

create table item (
    id int not null,
    title varchar(50) not null,
    description text not null,
    creator varchar(50) not null
);

create table user_ignored_items (
    id int not null,
    user_id int not null,
    item_id int not null
);

create table user_sessions (
    id int not null,
    user_id int not null,
    session_id varchar(100),
    session_exp datetime not null
);

create table user_friends (
    id int not null,
    user_id int not null
);

create table parental_controls (
    id int not null,
    user_id int not null,
    rating varchar(10),
    genre_id int not null
);

create table users (
    id int not null,
    email varchar(100) not null,
    password varchar(100) not null,
    image blob not null
);