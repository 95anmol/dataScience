#1
create table bajaj1 as (select STR_TO_DATE(Date, "%d-%M-%Y") as Date,  `Close Price`, 
	CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`bajaj auto`.Date, "%d-%M-%Y")) >= 20 then 
	avg(`Close Price`) over (order by STR_TO_DATE(`bajaj auto`.Date, "%d-%M-%Y") rows between 19 PRECEDING and current row) 
    else null end as `20 Day MA`,
    CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`bajaj auto`.Date, "%d-%M-%Y")) >= 50 then 
    avg(`Close Price`) over (order by STR_TO_DATE(`bajaj auto`.Date, "%d-%M-%Y") rows between 49 PRECEDING and current row) 
    else null end as `50 Day MA`
    from `bajaj auto`) ;


create table `eicher motors1` as (select STR_TO_DATE(Date, "%d-%M-%Y") as Date,  `Close Price`, 
	CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`eicher motors`.Date, "%d-%M-%Y")) >= 20 then 
	avg(`Close Price`) over (order by STR_TO_DATE(`eicher motors`.Date, "%d-%M-%Y") rows between 19 PRECEDING and current row) 
    else null end as `20 Day MA`,
    CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`eicher motors`.Date, "%d-%M-%Y")) >= 50 then 
    avg(`Close Price`) over (order by STR_TO_DATE(`eicher motors`.Date, "%d-%M-%Y") rows between 49 PRECEDING and current row) 
    else null end as `50 Day MA`
    from `eicher motors`) ;
    

create table `hero motocorp1` as (select STR_TO_DATE(Date, "%d-%M-%Y") as Date,  `Close Price`, 
	CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`hero motocorp`.Date, "%d-%M-%Y")) >= 20 then 
	avg(`Close Price`) over (order by STR_TO_DATE(`hero motocorp`.Date, "%d-%M-%Y") rows between 19 PRECEDING and current row) 
    else null end as `20 Day MA`,
    CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`hero motocorp`.Date, "%d-%M-%Y")) >= 50 then 
    avg(`Close Price`) over (order by STR_TO_DATE(`hero motocorp`.Date, "%d-%M-%Y") rows between 49 PRECEDING and current row) 
    else null end as `50 Day MA`
    from `hero motocorp`) ;
    
create table infosys1 as (select STR_TO_DATE(Date, "%d-%M-%Y") as Date,  `Close Price`, 
	CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(infosys.Date, "%d-%M-%Y")) >= 20 then 
	avg(`Close Price`) over (order by STR_TO_DATE(infosys.Date, "%d-%M-%Y") rows between 19 PRECEDING and current row) 
    else null end as `20 Day MA`,
    CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(infosys.Date, "%d-%M-%Y")) >= 50 then 
    avg(`Close Price`) over (order by STR_TO_DATE(infosys.Date, "%d-%M-%Y") rows between 49 PRECEDING and current row) 
    else null end as `50 Day MA`
    from infosys) ;
    
    
create table tcs1 as (select STR_TO_DATE(Date, "%d-%M-%Y") as Date,  `Close Price`, 
	CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(tcs.Date, "%d-%M-%Y")) >= 20 then 
	avg(`Close Price`) over (order by STR_TO_DATE(tcs.Date, "%d-%M-%Y") rows between 19 PRECEDING and current row) 
    else null end as `20 Day MA`,
    CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(tcs.Date, "%d-%M-%Y")) >= 50 then 
    avg(`Close Price`) over (order by STR_TO_DATE(tcs.Date, "%d-%M-%Y") rows between 49 PRECEDING and current row) 
    else null end as `50 Day MA`
    from tcs) ;
    

create table `tvs motors1` as (select STR_TO_DATE(Date, "%d-%M-%Y") as Date,  `Close Price`, 
	CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`tvs motors`.Date, "%d-%M-%Y")) >= 20 then 
	avg(`Close Price`) over (order by STR_TO_DATE(`tvs motors`.Date, "%d-%M-%Y") rows between 19 PRECEDING and current row) 
    else null end as `20 Day MA`,
    CASE when
    ROW_NUMBER() OVER(ORDER BY STR_TO_DATE(`tvs motors`.Date, "%d-%M-%Y")) >= 50 then 
    avg(`Close Price`) over (order by STR_TO_DATE(`tvs motors`.Date, "%d-%M-%Y") rows between 49 PRECEDING and current row) 
    else null end as `50 Day MA`
    from `tvs motors`) ;
    
    
select * from bajaj1;
#2
create table master as (select Date, null as `TCS`, null as `TVS`, null as `Infosys`,
	null as `Eisher`, null as `Hero`, bajaj1.`Close Price` as `Bajaj` from bajaj1);
    
ALTER TABLE master modify COLUMN `TCS` double, modify COLUMN `TVS` double, modify COLUMN `Infosys` double,
	modify COLUMN `Eisher` double, modify COLUMN `Hero` double;
# Changed column order using workbench functions

update master
inner join tcs1 on tcs1.Date = master.Date
set master.`TCS` = tcs1.`Close Price`;

update master
inner join `tvs motors1` on `tvs motors1`.Date = master.Date
set master.`TVS` = `tvs motors1`.`Close Price`;

update master
inner join infosys1 on infosys1.Date = master.Date
set master.`Infosys` = infosys1.`Close Price`;

update master
inner join `eicher motors1` on `eicher motors1`.Date = master.Date
set master.`Eisher` = `eicher motors1`.`Close Price`;

update master
inner join `hero motocorp1` on `hero motocorp1`.Date = master.Date
set master.`Hero` = `hero motocorp1`.`Close Price`;


select * from master;
#3
create table bajaj2 as (SELECT Date, `Close Price`,
case 
	when (`20 Day MA`) > (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) < lag(`50 Day MA`) over (order by Date)
		Then 'Buy'
    when (`20 Day MA`) < (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) > lag(`50 Day MA`) over (order by Date)
		Then 'Sell'
	else 'Hold'
end as `signal_buy/sell`
FROM bajaj1 order by Date);


create table `eicher motors2` as (SELECT Date, `Close Price`,
case 
	when (`20 Day MA`) > (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) < lag(`50 Day MA`) over (order by Date)
		Then 'Buy'
    when (`20 Day MA`) < (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) > lag(`50 Day MA`) over (order by Date)
		Then 'Sell'
	else 'Hold'
end as `signal_buy/sell`
FROM `eicher motors1` order by Date);


create table `hero motocorp2` as (SELECT Date, `Close Price`,
case 
	when (`20 Day MA`) > (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) < lag(`50 Day MA`) over (order by Date)
		Then 'Buy'
    when (`20 Day MA`) < (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) > lag(`50 Day MA`) over (order by Date)
		Then 'Sell'
	else 'Hold'
end as `signal_buy/sell`
FROM `hero motocorp1` order by Date);


create table infosys2 as (SELECT Date, `Close Price`,
case 
	when (`20 Day MA`) > (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) < lag(`50 Day MA`) over (order by Date)
		Then 'Buy'
    when (`20 Day MA`) < (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) > lag(`50 Day MA`) over (order by Date)
		Then 'Sell'
	else 'Hold'
end as `signal_buy/sell`
FROM infosys1 order by Date);


create table tcs2 as (SELECT Date, `Close Price`,
case 
	when (`20 Day MA`) > (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) < lag(`50 Day MA`) over (order by Date)
		Then 'Buy'
    when (`20 Day MA`) < (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) > lag(`50 Day MA`) over (order by Date)
		Then 'Sell'
	else 'Hold'
end as `signal_buy/sell`
FROM tcs1 order by Date);


create table `tvs motors2` as (SELECT Date, `Close Price`,
case 
	when (`20 Day MA`) > (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) < lag(`50 Day MA`) over (order by Date)
		Then 'Buy'
    when (`20 Day MA`) < (`50 Day MA`)
		and lag(`20 Day MA`) over (order by Date) > lag(`50 Day MA`) over (order by Date)
		Then 'Sell'
	else 'Hold'
end as `signal_buy/sell`
FROM `tvs motors1` order by Date);

select * from bajaj2;


create function day_signal (dateCheck Date)
returns char(50) deterministic
return (select `signal_buy/sell`
		from bajaj2
		where dateCheck = bajaj2.Date);
        
select day_signal ('2015-05-18') as `signal`;

select count(*) from `tvs motors2` where `signal_buy/sell` = 'Buy';
select count(*) from `tvs motors2` where `signal_buy/sell` = 'Sell';
select count(*) from `tvs motors2` where `signal_buy/sell` = 'Hold';

