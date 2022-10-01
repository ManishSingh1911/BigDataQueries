create database DB;
use DB;
Create table if not exists t1(ID int, year int, city String, amount int);
Load data local inpath 'AB.txt' overwrite into table t1;
Select city, sum(amount) as x from t1 group by city order by x desc;