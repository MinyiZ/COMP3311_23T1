  EID ENAME             AGE     SALARY
----- --------------- ----- ----------
    1 John Smith         26      25000
    2 Jane Doe           40      55000
    3 Jack Jones         55      35000
    4 Superman           35      90000
    5 Jim James          20      20000

  DID DNAME               BUDGET  MANAGER
----- --------------- ---------- --------
    1 Sales               500000        2
    2 Engineering        1000000        4
    3 Service             200000        4

  EID   DID  PCT_TIME
----- ----- ---------
    1     2      1.00
    2     1      1.00
    3     1      0.50
    3     3      0.50
    4     2      0.50
    4     3      0.50
    5     2      0.75

=================================================

For each of the following cases, show how deletion of the Engineering department would affect the database:

------------------
ON DELETE CASCADE
------------------

  DID DNAME               BUDGET  MANAGER
----- --------------- ---------- --------
    1 Sales               500000        2
    3 Service             200000        4

  EID   DID  PCT_TIME
----- ----- ---------
    2     1      1.00
    3     1      0.50
    3     3      0.50
    4     3      0.50


DELETE SET NULL
------------------

  DID DNAME               BUDGET  MANAGER
----- --------------- ---------- --------
    1 Sales               500000        2
    3 Service             200000        

  EID   DID  PCT_TIME
----- ----- ---------
    1            1.00
    2     1      1.00
    3     1      0.50
    3     3      0.50
    4            0.50
    4     3      0.50
    5            0.75


------------------
DELETE SET DEFAULT (default is did=1)
------------------

  DID DNAME               BUDGET  MANAGER
----- --------------- ---------- --------
    1 Sales               500000        2
    3 Service             200000        

  EID   DID  PCT_TIME
----- ----- ---------
    1     1      1.00
    2     1      1.00
    3     1      0.50
    3     3      0.50
    4     1      0.50
    4     3      0.50
    5     1      0.75