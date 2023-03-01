-- q2a

create table Subject (
    subjCode text,

    primary key (subjCode)
);

create table Teacher (
    staffID integer,
    subject text,
    semester text,

    primary key (staffID),
    foreign key (subject) references Subject(subjCode)
);


-- q2b

create table Subject (
    subjCode text,

    primary key (subjCode)
);

create table Teacher (
    staffID integer,

    primary key (staffID),
);

create table Teaches (
    teacher integer,
    subject text,
    semester text,

    primary key (teacher, subject, semester),
    foreign key (teacher) references Teacher(staffID),
    foreign key (subject) references Subject(subjCode)
);

-- q2c

create table Subject (
    subjCode text,
    teacher text not null unique,
    semester text,

    primary key (subjCode),
    foreign key (teacher) references Teacher(staffID),
);

create table Teacher (
    staffID integer,

    primary key (staffID),
);
