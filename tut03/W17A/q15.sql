create table Teams (
    name text,
    captain text not null unique,

    primary key (name),
    foreign key (captain) reference Players(name)
);

create table Fans (
    name text,

    primary key (name)
);

create table Players (
    name text,
    team text not null,

    primary key (name),
    foreign key (team) reference Teams(name)
);

create table TeamColours (
    team text,
    colour text,

    primary key (team, colour),
    foreign key (team) reference Teams(name)
);

create table FavColours (
    fan text,
    colour text,

    primary key (fan, colour),
    foreign key (fan) reference Fans(name)
);

create table FavPlayers (
    fan text,
    player text,

    foreign key (fan) reference Fans(name),
    foreign key (player) reference Players(name),
);

create table FavTeams (
    fan text,
    team text,

    foreign key (fan) reference Fans(name),
    foreign key (team) reference Teams(name),
);