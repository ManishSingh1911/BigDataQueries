--KNN
--Change hive setting to allow cartesian product
hive> set hive.strict.checks.cartesian.product=false;

--Create a table and load the data 'score.csv'
create table if not exists score (seat int, midterm int, att double, hw double, quiz double, final double, total double)
row format delimited
fields terminated by ','
stored as textfile
tblproperties('skip.header.line.count' = '1');  

load data local inpath 'score.csv' overwrite into table score;

--1.
--Fill empty (null) values with average column values. 
Create table if not exists averages as
select avg(midterm), avg(att), avg(hw), avg(quiz), avg(final), avg(total)
from score;

Select * from averages;

--check the column names
describe averages;
drop table averages;

Create table if not exists averages as
select avg(midterm) as avg_midterm, avg(att) as avg_att, avg(hw) as avg_hw, avg(quiz) as avg_quiz, avg(final) as avg_final, avg(total)as avg_total
from score;

/*
Create view if not exists score1 as 
select seat,
if (midterm is null, avg_midterm, midterm),
if (att is null, avg_att, att),
if (hw is null, avg_hw, hw),
if (quiz is null, avg_quiz, quiz),
if (final is null, avg_final, final),
if (total is null, avg_total, total)
from score, averages;

Select * from score1;

Describe score1;
drop view score1;
*/

Create view if not exists score1 as 
select seat, 
if (midterm is null, avg_midterm, midterm) as midterm,
if (att is null, avg_att, att) as att,
if (hw is null, avg_hw, hw) as hw,
if (quiz is null, avg_quiz, quiz) as quiz,
if (final is null, avg_final, final) as final,
if (total is null, avg_total, total) as total
from score, averages;

Select * from score1;

--2.
--Find the 10 nearest neighbors (records) to the first record based on midterm.
--Select midterm from score1 limit 1; --select midterm from the first record

Select score1.*, abs(score1.midterm-b.midterm) as dist from score1, (select midterm from score1 limit 1) as b 
order by dist limit 10;

--3.
--Find the 5 nearest neighbors (records) to the first record based on midterm and quiz. 

Select score1.*, sqrt(pow(score1.midterm-b.midterm, 2) + pow(score1.quiz-b.quiz, 2)) as dist from score1, (select midterm, quiz from score1 limit 1) as b 
order by dist limit 5;

Practice 12. Find the 5 nearest neighbors to the record with seat 17 and midterm 79 based on hw and quiz. 

--Simple Linear Regression
--3.1. Score.csv
--1. Find the estimates (beta1, beta0) for h_total and final as x, y respectively. 

Create view if not exists score2 as
select hw as x, final as y from score 
where hw is not null and final is not null;

Create view if not exists averages1 as
select avg(x) as avg_x, avg(y) as avg_y from score2;

Create view if not exists diff as
select (x -avg_x) as xdiff, (y-avg_y) as ydiff from score2, averages1;

--From here to find beta0 and beta1.

Practice 13. 
Find the estimates (beta1, beta0) for q_total and midterm as x, y respectively. 