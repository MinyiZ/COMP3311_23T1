create table Faculty (
    id text,

    primary key (id)
);

create table Lectuer (
    id text,
    deanOf text unique,

    primary key (id),
    foreign key deanOf references Faculty(id)
);

create table School (
    id text,
    faculty text,

    primary key (id),
    foreign key (faculty) references Faculty(id)
);

create table Subject (
    id text,

    primary key (id)
);

create table Teaches (
    lecturer text,
    subject text,

    foreign key lecturer references Lectuer(id),
    foreign key subject references Subject(id)
);