create table Employees (
      eid     integer,
      ename   text,
      age     integer,
      salary  integer,

      primary key (eid),
      check (salary >= 15000)
);

create table Departments (
      did     integer,
      dname   text,
      budget  integer,
      manager integer unique not null,

      primary key (did),
      foreign key (manager) references Employees(eid)
);

create table WorksIn (
      eid     integer,
      did     integer default 1,
      percent real,

      primary key (eid,did),
      foreign key (eid) references Employees(eid),
      foreign key (did) references Departments(did) on delete set default
);
