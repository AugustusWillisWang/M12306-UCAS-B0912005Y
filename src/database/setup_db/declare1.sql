-- 打开数据库
-- psql -U dbms -d test12306

-- drop database test12306;
-- create database test12306;

CREATE TABLE ID_Station_City(
    ISC_sid INTEGER  , 
    ISC_sname CHAR(20)  ,
    ISC_cname CHAR(20)  ,
    primary key (ISC_sid)
    -- foreign key () references x(x)
);

CREATE TABLE Train(
    T_tid char(10)  ,
    T_start_sid int,
    T_end_sid int,
    primary key (T_tid),
    foreign key (T_start_sid) references ID_Station_City(ISC_sid),
    foreign key (T_end_sid) references ID_Station_City(ISC_sid)

);

CREATE TABLE Train_Table(
    TT_tid char(10)  ,
    TT_sid int  ,
    TT_depart_time time  ,
    TT_arrive_time time  ,
    TT_time int,
    TT_price_yz decimal  ,
    TT_price_rz decimal  ,
    TT_price_yws decimal  ,
    TT_price_ywz decimal  ,
    TT_price_ywx decimal  ,
    TT_price_rws decimal  ,
    TT_price_rwx decimal  ,
    TT_count    int,
    primary key (TT_tid,TT_sid),
    foreign key (TT_tid) references Train(T_tid),
    foreign key (TT_sid) references ID_Station_City(ISC_sid)
);
--???

CREATE TABLE Empty_Seat(
    ES_tid char(10),
    ES_current_sid int  ,
    ES_next_sid int,
    ES_date date  ,
    ES_left_yz int  ,
    ES_left_rz int  ,
    ES_left_yws int  ,
    ES_left_ywz int  ,
    ES_left_ywx int  ,
    ES_left_rws int  ,
    ES_left_rwx int  ,
    primary key (ES_tid,ES_current_sid,ES_date),
    foreign key (ES_current_sid) references ID_Station_City(ISC_sid),
    foreign key (ES_next_sid) references ID_Station_City(ISC_sid)
);

CREATE TABLE Passenger(
    P_pid int,
    P_phone int,
    P_pname char(20),
    P_uname char(30),
    P_credit_card int,
    primary key (P_pid)
);

CREATE TABLE Orders(
    O_oid int  ,
    O_pid int  ,

    O_start_sid int  ,
    O_arrive_sid int  ,

    O_date1 date  ,
    O_time1 time  ,
    O_tid1 char(10)  ,
    O_start_sid1 int  ,
    O_arrive_sid1 int  ,

    O_date2 date,
    O_time2 time,
    O_tid2 char(10),
    O_start_sid2 int,
    O_arrive_sid2 int,

    O_price decimal  ,
    primary key (O_oid),
    foreign key (O_pid) references Passenger(P_pid),
    foreign key (O_tid1) references Train(T_tid),
    foreign key (O_tid2) references Train(T_tid),
    foreign key (O_start_sid) references ID_Station_City(ISC_sid),
    foreign key (O_arrive_sid) references ID_Station_City(ISC_sid),
    foreign key (O_start_sid1) references ID_Station_City(ISC_sid),
    foreign key (O_arrive_sid1) references ID_Station_City(ISC_sid),
    foreign key (O_start_sid2) references ID_Station_City(ISC_sid),
    foreign key (O_arrive_sid2) references ID_Station_City(ISC_sid)

);

CREATE TABLE Station_Connection(
    SC_depart_sid int  ,
    SC_arrive_sid int  ,
    SC_tid char(10)  ,
    primary key (SC_depart_sid,SC_arrive_sid,SC_tid),
    foreign key (SC_depart_sid) references ID_Station_City(ISC_sid),
    foreign key (SC_arrive_sid) references ID_Station_City(ISC_sid),
    foreign key (SC_tid) references Train(T_tid)
);

CREATE TABLE City_Connection(
    CC_depart_city char(20)  ,
    CC_arrive_city char(20)  ,
    CC_tid char(10)  ,
    -- primary key (CC_depart_city,CC_arrive_city,CC_tid),
    foreign key (CC_tid) references Train(T_tid)
);

-- 导入站表

-- https://www.postgresql.org/docs/9.2/sql-copy.html

COPY ID_Station_City FROM '/mnt/hgfs/DB-m12306/data/all-stations.txt' WITH DELIMITER ',' NULL AS '' CSV;

--OK

-- 导入每次列车信息

COPY Train FROM '/mnt/hgfs/DB-m12306/data/train.csv' WITH DELIMITER ',' NULL AS '' CSV;

COPY Train_Table FROM '/mnt/hgfs/DB-m12306/data/output.csv' WITH DELIMITER ',' NULL AS '' CSV;

COPY Station_Connection FROM '/mnt/hgfs/DB-m12306/data/ss.csv' WITH DELIMITER ',' NULL AS '' CSV;

COPY City_Connection FROM '/mnt/hgfs/DB-m12306/data/cc.csv' WITH DELIMITER ',' NULL AS '' CSV;

-- DROP TABLE ori_1095;

-- CREATE TABLE ori_1095(
--     insid INTEGER,
--     sname CHAR(20),
--     arrive_time CHAR(20),
--     depart_time CHAR(20),
--     stay_time CHAR(20),
--     duration_time CHAR(20),
--     duration_km INTEGER,
--     yz_rz CHAR(40),
--     yw CHAR(40),
--     rw CHAR(40)
--     );

-- COPY ori_1095 FROM '/mnt/hgfs/DB-m12306/data/0/1095.csv' WITH 
-- DELIMITER AS ',' 
-- NULL AS ''
-- HEADER
-- CSV ;


-- CREATE TABLE t_1095(
--     insid INTEGER,
--     sname CHAR(20),
--     arrive_time TIME,
--     depart_time TIME,
--     price_yz decimal,
--     price_rz decimal,
--     price_yws decimal,
--     price_ywz decimal,
--     price_ywx decimal,
--     price_rws decimal,
--     price_rwx decimal
--     );

--TODO: 将上面的原始数据解析成这样的可用数据

-- substring(string from pattern)


-- HEADER QUOTE AS ',';
-- https://www.cnblogs.com/dview112/archive/2012/10/22/2733706.html

-- SQL 参数用法
-- psql -v v1=12 -v v2="'Hello World'"
-- and then refer to the variables in sql as :v1, :v2 etc

-- select * from table_1 where id = :v1;