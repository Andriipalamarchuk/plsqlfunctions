alter session set "_ORACLE_SCRIPT"=true;
create user mybank identified by password ;
grant connect to mybank ;
grant create table to mybank ;
grant create procedure to mybank ;
grant create sequence to mybank;
alter user mybank quota unlimited on users ;
commit; 
create table customer 
(
  id number,
  name varchar2(14),
  surname varchar2(18),
  ssn varchar2(18), 
  birthdate date, 
  birthcoutry varchar2(18)
);
alter table customer
add constraint pk_customer PRIMARY KEY(id)
;
create unique index index_customer
on customer(name, surname, ssn) 
;
create table account 
(
  id number,
  currency varchar2(7),
  balance number,
  id_customer number
);
alter table account
add constraint pk_account PRIMARY KEY(id)
;
alter table account
add constraint fk_account
foreign key (id_customer)
references customer(id)
;
create or replace procedure withdraw
  (account number, amount number)
is

begin
  update ACCOUNT
  set balance= balance - amount 
  where id = account ;
end withdraw;

create or replace procedure deposit
  (account number, amount number)
is

begin
  update ACCOUNT
  set balance= balance + amount 
  where id = account ;
end deposit;

create table movements 
(
    id number,
    account number,
    amount number,
    constraint pk_movements PRIMARY KEY (id)
);

alter table movements
add constraint fk_movements
foreign key (account)
references account(id)
;
create or replace function get_balance
  (p_account number)
  return number
as
  saldo number;
  v_amount number;
begin 
  select balance 
  into saldo
  from ACCOUNT
  where id = p_account;
  select sum (amount) 
  into v_amount 
  from movements
  where account = p_account;
  saldo:=saldo+v_amount;
  return saldo;
end get_balance;
  