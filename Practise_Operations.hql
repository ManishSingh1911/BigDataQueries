--Practice
Select 2+3;
Select (1+3)*2;

--Different with pig
Select 7/2; 

--Quotient
Select 7 div 2; 

--Remainder
Select 7 % 2; 

--Not working
Select 2^3; 
Select 2**3; 

Select power(2, 3);
Select pow(3,3);
Select ceil(2.3);
Select ceiling(3.4);
Select floor(3.9);
Select round(3.4);
Select round(3.6);

Select 'abc';
Select "abc";

--Not working
Select 'abc' + '123'; 

--String concatenation
Select concat('abc', '123', 'UCM'); 

/*Hive function split(string str, string deliminator) is 
similar to TOKENIZE()in pig*/
Select split('abc 123 UCM', ' '); 
Select split('abc 123 UCM', ' ')[2]; 
Select split('abc,123 UCM', ' '); 
Select split('abc   123  UCM', ' '); 
Select split("abc 123 UCM", ' '); 
Select split('abc,123,UCM', ',');
Select split('abc      123\t\t\t         UCM', '\\s+');

/*Hive function explode() is 
similar to FLATTEN()in pig*/
Select explode(array('abc', '123', 'UCM')); 

--Combine split and explode functions
Select explode(split('abc 123 UCM', ' ')); 
Select explode(split('abc   \t    123\t    UCM', '\\s+'));

--Pay attention to this operation
Select '123'+21; 
Select '123'=123;

Select sqrt(2);
Select rand();
--rand(seed)
Select rand(5);

Practice: Get a random integer number between 1 and 6 with seed 5.

--substr(string A, int start, int length)
Select substr('abc123UCM', 4, 3); 
Select substr('abc123UCM', 4); 

Select upper('abcde');
Select lower('ABCDE');
Select trim('     abc123 UCM    ');
Select ltrim('     abc123 UCM    ');
Select rtrim('     abc123 UCM    ');
Select pi();
Select length('abc123UCM');

Select current_date();

--Not working
Select currect_time(); 

--Display current UTC time
Select current_timestamp(); 


--1
--Create a database bigdata
Create database bigdata;

--Show databases
Show databases;

--2
--Enter the database bigdata
Use bigdata;

--3
--Create a table called weather
Create table weather (year int, temperature float, quality int);

--4
--Display schema of the table weather 
Describe weather;

--5
--Create a view called word
Create view word as select year from weather;

--6
--Display schema of the view word 
Describe word;

--7
--Show all tables in bigdata
Show tables;

--8
--Drop table weather
Drop table weather;

--9
--Drop view word
Drop view word;

--10
--Drop database bigdata
Drop database bigdata;

--11
--Create a table called weather with the weather dataset
create table if not exists weather (year int, temperature float, quality int)
row format delimited
fields terminated by '\t'
lines terminated by '\n'
stored as textfile;

--12
--Select all records from weather table
Select * from weather;
	
--13
--Load weather.txt to the table weather
Load data local inpath 'weather.txt' overwrite into table weather;

--What happend if we use the following statement?
Load data local inpath 'weather.txt' into table weather;

--14
--Show year from weather
Select year from weather;
Select distinct year from weather;

--15
--Show temperature from weather
Select temperature from weather;

--16
--Show year and temperature from weather
Select year, temperature from weather;

--17
--Show year and temperature in Celsius from weather
Select year, (temperature-32)*5/9 as tempc, quality from weather;
Create table weather_c as select year, (temperature-32)*5/9 as tempc, quality from weather;
Create view weather_vc as select year, (temperature-32)*5/9 as tempc, quality from weather;

--18
--Show records of weather with year equal to 1950
Select * from weather 
where year=1950;

--19
--Show the total number of records from weather
Select count(*) from weather;

--20
--Show the total number of records from weather with year equal to 1949.
Select count(*) from weather
where year=1949;

--21
--Show the max temperature from weather
Select max(temperature) from weather;

--22
--Show the max temperatures for each year from weather
Select year, max(temperature) from weather
group by year;

--23
--Show the number of records for each year from weather and sort them by the number of records in descending order
--there are errors in the code below
Select year, count(*) from weather
group by year
order by count(*) desc;

--The code below is working
Select year, count(*) as cnt from weather
group by year
order by cnt desc;

--24
--What happends if we change the temperature to integer?
create table if not exists weather1 (year int, temperature int, quality int)
row format delimited
fields terminated by '\t'
stored as textfile;
load data local inpath 'weather.txt' overwrite into table weather1;
select * from weather1;


--Work on hello.txt for word count 
create table if not exists lines (line string);
load data local inpath 'hello.txt' overwrite into table lines;
create view if not exists words as select explode(split(line,'\\s+')) as word from lines;
select word, count(*) from words having count(*)>=2;
group by word;

Pratice 9: 
Display word, count pair in descending order in count.
Display word, count pair in decending order in count, including word count at least 2.

--get a small taxi data 
[hadoop@ip-?-?-?-? ~]$ head nyc_taxi_data_2014.csv -n 100 > small_nyc.csv;

create table if not exists nyc
(vendor_id string, pickup_datetime string, dropoff_datetime string, passenger_count int, trip_distance double, pickup_longitude double, pickup_latitude double, rate_code int, store_and_fwd_flag string, dropoff_longitude double, dropoff_latitude double, payment_type string, fare_amount double, surcharge double, mta_tax double, tip_amount double, tolls_amount double, total_amount double)
row format delimited
fields terminated by ','
stored as textfile
--cuts off the first line or header
tblproperties('skip.header.line.count' = '1');

load data local inpath 'small_nyc.csv' overwrite into table nyc;

25.	Show the count of all records
Select count(*) from nyc;

26.	Show the count of the records with passenger_count equal to 2
Select count(*) from nyc 
where passenger_count = 2;

27.	Show the count of the records for each passenger count
Select passenger_count, count(*) from nyc 
group by passenger_count;

28.	Show the count and average tip_amount for each passenger count
Select passenger_count, avg(tip_amount) 
from nyc 
group by passenger_count;

--Work on the data set nyc_taxi_data_2014.csv
Pratice 10:
1. Show the total tip_amount for each passenger_count.
2. Show the total trip_distance for each passenger_count.
3. Show the average tip_amount per unit trip_distance for each passenger_count and display by the average in descending order.


--Drop all the tables in the database in Linux shell
hive -e 'show tables' | xargs -I '{}' hive -e 'drop table {}'

--Drop all the views in the database in Linux shell
hive -e 'show views' | xargs -I '{}' hive -e 'drop view {}'

--Running Hive in batch mode

[hadoop@ip-?-?-?-? ~]$ hive -f Wordcounthive.hql

--Running Hive in HDFS

--Send a file to HDFS
[hadoop@ip-?-?-?-? ~]$ hadoop fs -put weather.txt
--List all files in HDFS
[hadoop@ip-?-?-?-? ~]$ hadoop fs -ls 
[hadoop@ip-?-?-?-? ~]$ hive
hive>
create table if not exists HDFS_weather (year int, temperature float, quality int)
row format delimited
fields terminated by '\t'
stored as textfile;
load data inpath 'weather.txt' overwrite into table HDFS_weather;
select * from HDFS_weather;

Practice 11.
Please do the word count of the file hello.txt in HDFS.
Display word, count pair in decending order in count, including word count at least 2.

--Save the created table 
--Use the default delimiter   
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/FrequentWords' select * from frequent_word; 

--Provide a specified delimiter
INSERT OVERWRITE LOCAL DIRECTORY '/home/hadoop/FrequentWords1' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' select * from frequent_word; 



