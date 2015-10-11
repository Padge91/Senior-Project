--this file creates all tables with their appropriate types and constraints
create table users (
    id bigint not null auto_increment,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    password varchar(150) not null,
    salt char(50) not null,
    image blob null,
    primary key(id)
);

create table items (
    id bigint not null auto_increment,
    type varchar(15) not null,
    title varchar(100) not null,
    description text not null,
    creator varchar(50) not null,
    primary key(id)
);

create table genres (
    id bigint not null auto_increment,
    name varchar(15) unique,
    primary key(id)
);

create table comments (
    id bigint not null auto_increment,
    user_id bigint not null,
    create_date datetime not null,
    content text not null,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table comment_parents (
    id bigint not null auto_increment,
    parent_id bigint not null,
    child_id bigint not null,
    primary key(id)
);

create table comment_ratings (
    id bigint not null auto_increment,
    user_id bigint not null,
    comment_id bigint not null,
    rating boolean not null,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(comment_id) references comments(id)
);

create table libraries (
    id bigint not null auto_increment,
    user_id bigint not null,
    library_name varchar(30),
    visible boolean default true not null,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table library_items (
    id bigint not null auto_increment,
    library_id bigint not null,
    item_id bigint not null,
    primary key(id),
    foreign key(library_id) references libraries(id),
    foreign key(item_id) references items(id)
);

create table item_statistics (
    id bigint not null auto_increment,
    item_id bigint not null,
    last_viewed datetime not null,
    views int not null,
    primary key(id),
    foreign key(item_id) references items(id)
);

create table item_images (
    id bigint not null auto_increment,
    item_id bigint not null,
    image_url varchar(200) not null,
    primary key(id),
    foreign key(item_id) references items(id)
);

create table item_genres (
    id bigint not null auto_increment,
    item_id bigint not null,
    genre_id bigint not null,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(genre_id) references genres(id)
);

create table item_reviews (
    id bigint not null auto_increment,
    item_id bigint not null,
    user_id bigint not null,
    review_value int,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(user_id) references users(id)
);

create table item_comments (
    id bigint not null auto_increment,
    item_id bigint not null,
    comment_id bigint not null,
    primary key(id)
);

create table user_ignored_items (
    id bigint not null auto_increment,
    user_id bigint not null,
    item_id bigint not null,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(user_id) references users(id)
);

create table user_sessions (
    id bigint not null auto_increment,
    user_id bigint not null,
    session_id varchar(100),
    session_exp datetime null,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table user_friends (
    id bigint not null auto_increment,
    user_id bigint not null,
    friend_id bigint not null,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(user_id) references users(id)
);

create table user_parental_controls (
    id bigint not null auto_increment,
    user_id bigint not null,
    rating varchar(10),
    genre_id bigint not null,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(genre_id) references genres(id)
);

create table item_children (
    id bigint not null auto_increment,
    parent_item_id bigint not null,
    child_item_id bigint not null,
    primary key(id),
    foreign key(parent_item_id) references items(id),
    foreign key(child_item_id) references items(id)
);
