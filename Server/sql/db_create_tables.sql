--this file creates all tables with their appropriate types and constraints
create table users (
    id int not null auto_increment,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    password varchar(150) not null,
    salt char(50) not null,
    image blob null,
    primary key(id)
);

create table items (
    id int not null auto_increment,
    type varchar(15) not null,
    title varchar(50) not null,
    description text not null,
    creator varchar(50) not null,
    primary key(id)
);

create table genres (
    id int not null auto_increment,
    name varchar(15) unique,
    primary key(id)
);

create table comments (
    id int not null auto_increment,
    user_id int not null,
    create_date datetime not null,
    content text not null,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table comment_parents (
    id int not null auto_increment,
    parent_id int not null,
    child_id int not null,
    primary key(id),
    foreign key(parent_id) references comments(id),
    foreign key(child_id) references comments(id)
);

create table comment_ratings (
    id int not null auto_increment,
    user_id int not null,
    comment_id int not null,
    rating boolean not null,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(comment_id) references comments(id)
);

create table libraries (
    id int not null auto_increment,
    user_id int not null,
    library_name varchar(30),
    visible boolean default true not null,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table library_items (
    id int not null auto_increment,
    library_id int not null,
    item_id int not null,
    primary key(id),
    foreign key(library_id) references libraries(id),
    foreign key(item_id) references items(id)
);

create table item_statistics (
    id int not null auto_increment,
    item_id int not null,
    last_viewed datetime not null,
    views int not null,
    primary key(id),
    foreign key(item_id) references items(id)
);

create table item_images (
    id int not null auto_increment,
    item_id int not null,
    image blob not null,
    primary key(id),
    foreign key(item_id) references items(id)
);

create table item_genres (
    id int not null auto_increment,
    item_id int not null,
    genre_id int not null,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(genre_id) references genres(id)
);

create table item_reviews (
    id int not null auto_increment,
    item_id int not null,
    user_id int not null,
    review_value int,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(user_id) references users(id)
);

create table item_comments (
    id int not null auto_increment,
    item_id int not null,
    comment_id int not null,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(comment_id) references comments(id)
);

create table user_ignored_items (
    id int not null auto_increment,
    user_id int not null,
    item_id int not null,
    primary key(id),
    foreign key(item_id) references items(id),
    foreign key(user_id) references users(id)
);

create table user_sessions (
    id int not null auto_increment,
    user_id int not null,
    session_id varchar(100),
    session_exp datetime null,
    primary key(id),
    foreign key(user_id) references users(id)
);

create table user_friends (
    id int not null auto_increment,
    user_id int not null,
    friend_id int not null,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(user_id) references users(id)
);

create table user_parental_controls (
    id int not null auto_increment,
    user_id int not null,
    rating varchar(10),
    genre_id int not null,
    primary key(id),
    foreign key(user_id) references users(id),
    foreign key(genre_id) references genres(id)
);

create table item_children (
    id int not null auto_increment,
    parent_item_id int not null,
    child_item_id int not null,
    primary key(id),
    foreign key(parent_item_id) references items(id),
    foreign key(child_item_id) references items(id)
);
