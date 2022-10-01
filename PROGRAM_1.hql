set hive.strict.checks.cartesian.product=false;
create database if not exists HW4;
use HW4;
create table if not exists score (seat int, midterm int, att double, hw double, quiz double, final double, total double)
row format delimited
fields terminated by ','
stored as textfile
tblproperties('skip.header.line.count' = '1');
load data local inpath 'score.csv' overwrite into table score;
Create table if not exists averages as
select avg(midterm) as avg_midterm, avg(att) as avg_att, avg(hw) as avg_hw, avg(quiz) as avg_quiz, avg(final) as avg_final, avg(total)as avg_total
from score;
Create view if not exists score1 as select seat, 
if (midterm is null, avg_midterm, midterm) as midterm,
if (att is null, avg_att, att) as att,
if (hw is null, avg_hw, hw) as hw,
if (quiz is null, avg_quiz, quiz) as quiz,
if (final is null, avg_final, final) as final,
if (total is null, avg_total, total) as total
from score, averages;
Select score1.*, sqrt(pow(score1.midterm-b.midterm, 2) + pow(score1.quiz-b.quiz, 2) + pow(score1.final-b.final, 2)) as dist from score1, (select midterm, quiz, final from score1 where seat=54 and midterm=110) as b order by dist limit 5;

