create role role_user;
create role role_admin;

-------------------------------------
grant create session,
    execute any procedure,
    select any table
    to role_user;

create user UserShop
identified by Password
default tablespace TS_HOBBIES_SHOP QUOTA UNLIMITED ON TS_HOBBIES_SHOP
temporary tablespace TS_HOBBIES_SHOP_TEMP
ACCOUNT UNLOCK;

GRANT role_user to UserShop;
--------------------------------------------
create user AdminShop
identified by Password
default tablespace TS_HOBBIES_SHOP QUOTA UNLIMITED ON TS_HOBBIES_SHOP
temporary tablespace TS_HOBBIES_SHOP_TEMP
ACCOUNT UNLOCK;


grant create session,
    execute any procedure,
    alter any table,
    insert any table,
    select any table,
    update any table,
    alter any index,
    alter any trigger,
    create view
    to role_admin;

GRANT role_admin to AdminShop;
----------------------------------------

create tablespace TS_HOBBIES_SHOP
  datafile 'C:\app\ora_admin\TS_HOBBIES_SHOP1.dbf'
  size 10m
  autoextend on next 500k
  maxsize 1000m
  extent management local;

  create temporary tablespace TS_HOBBIES_SHOP_TEMP
  tempfile 'C:\app\ora_admin\TS_HOBBIES_SHOP_TEMP1.dbf'
  size 7m
  autoextend on next 500k
  maxsize 1000m
  extent management local;
