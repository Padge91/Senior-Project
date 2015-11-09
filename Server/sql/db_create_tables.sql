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
    primary key(id)
);

create table movies (
    id bigint not null auto_increment,
    item_id bigint not null,
    rating varchar(10) not null,
    release_date varchar(20) not null,
    runtime_minutes int not null,
    director varchar(50) not null,
    writer varchar(50) not null,
    studio varchar(50) not null,
    actors varchar(400) not null,
    primary key(id)
);

create table books (
    id bigint not null auto_increment,
    item_id bigint not null,
    publish_date varchar(20) not null,
    num_pages int not null,
    authors varchar(400) not null,
    publisher varchar(100) not null,
    edition varchar(50) not null,
    primary key(id)
);

create table games (
    id bigint not null auto_increment,
    item_id bigint not null,
    publisher varchar(100) not null,
    studio varchar(50) not null,
    release_date varchar(20) not null,
    rating varchar(10) not null,
    game_length int not null,
    multiplayer boolean not null,
    singleplayer boolean not null,
    primary key(id)
);

create table music (
    id bigint not null auto_increment,
    item_id bigint not null,
    release_date varchar(20) not null,
    recording_company varchar(50) not null,
    artist varchar(50) not null,
    time_length varchar(10) not null,
    primary key(id)
);

create table television (
    id bigint not null auto_increment,
    item_id bigint not null,
    time_length varchar(20) not null,
    air_date varchar(20) not null,
    channel varchar(30) not null,
    actors varchar(400) not null,
    director varchar(50) not null,
    writer varchar(50) not null,
    rating varchar(10) not null,
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
    genre varchar(20) not null,
    primary key(id),
    foreign key(item_id) references items(id)
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
);

create table item_children (
    id bigint not null auto_increment,
    parent_item_id bigint not null,
    child_item_id bigint not null,
    primary key(id),
    foreign key(parent_item_id) references items(id),
    foreign key(child_item_id) references items(id)
);

create table comment_flags (
    id bigint not null auto_increment,
    comment_id bigint not null,
    user_id bigint not null,
    primary key(id),
    foreign key(comment_id) references comments(id),
    foreign key(user_id) references users(id)
);