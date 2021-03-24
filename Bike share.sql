--Q1- How many trips were there in each month of each year? 
---this query use  databases for both companies (Bluebikes and Baywheels)


with
--step1--blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


--step2--baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


---step 3-- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined)

--step 4 - counting trips in each month of each year
select  Count(total_bike_data.bike_id) as trips, 
					  extract(month from total_bike_data.start_time) as month, extract(year from total_bike_data.start_time) as year
					  from total_bike_data
					  group by month , year
					  order by month asc
					  
					  
					  
----for bluebikes only		  
					  
	
with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined)

--- counting trips in each month of each year
select  Count(total_bike_data.bike_id) as trips, 
					  extract(month from total_bike_data.start_time) as month, extract(year from total_bike_data.start_time) as year
					  from total_bike_data
					  where company_name= 'bluebikes'
					  group by month , year
					  order by month asc				  
	------------------------------------------------------------------				  
q2- Which stations are showing the greatest growth rates?


with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),

--- --extracting start_station info and counting trips per station in current year  
counts_year as	(select  start_station_id,Count(bike_id) as trips_current_year
				  from total_bike_data
				 where company_name= 'bluebikes'
				   group by  start_station_id
				 )
--main query starts here
--extracting start_station info,counting trips per station in current and previous year and generating growth rate.
select  start_station_id,  
        trips_current_year,
	    LAG(trips_current_year,1) over(  order by trips_current_year) as trips_previous_year,
		100 * ((trips_current_year-LAG(trips_current_year,1) over(order by trips_current_year))::float/trips_current_year::float) || '%' as growth_rate  
		from counts_year
----------------------------------------------------------------------------------------
---bluebikes data growth

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),

--- --extracting start_station info and counting trips per station in current year  
counts_year as	(select  start_station_id,Count(bike_id) as trips_current_year
				  from total_bike_data
				 where company_name= 'bluebikes'
				   group by  start_station_id
				 )
--main query starts here
--extracting start_station info,counting trips per station in current and previous year and generating growth rate.
select  start_station_id,  
        trips_current_year,
	    LAG(trips_current_year,1) over(  order by trips_current_year) as trips_previous_year,
		100 * ((trips_current_year-LAG(trips_current_year,1) over(order by trips_current_year))::float/trips_current_year::float) || '%' as growth_rate  
		from counts_year
		
------ baywheels growth-----

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),

--- --extracting start_station info and counting trips per station in current year  
counts_year as	(select  start_station_id,Count(bike_id) as trips_current_year
				  from total_bike_data
				 where company_name= 'baywheels'
				   group by  start_station_id
				 )
--main query starts here
--extracting start_station info,counting trips per station in current and previous year and generating growth rate.
select  start_station_id,  
        trips_current_year,
	    LAG(trips_current_year,1) over(  order by trips_current_year) as trips_previous_year,
		100 * ((trips_current_year-LAG(trips_current_year,1) over(order by trips_current_year))::float/trips_current_year::float) || '%' as growth_rate  
		from counts_year
		
--Q3- IS THERE A DIFFERENCE IN GROWTH BETWEEN HOLIDAY ACTIVITY AND COMMUTING ACTIVITY? combined

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),

-----extracting 
date_info as ( Select Count(bike_id) as trips_current_day,
	    case 
			  when extract(dow from start_time)=0 or extract(dow from start_time)=6 then 'weekend'
			  else 'weekday' end as day_type
		from total_bike_data
		group by day_type 
				 )

				 
--main query starts here
--extracting trips info for weekday n weekends
select  trips_current_day, day_type,
	    LAG(trips_current_day,1) over(  order by trips_current_day) as trips_previous,
		100 * ((trips_current_day-LAG(trips_current_day,1) over(order by trips_current_day))::float/trips_current_day::float) || '%' as growth_rate  
		from date_info	



---bluebikes----------------------------------------------------------

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),

-----extracting 
date_info as ( Select Count(bike_id) as trips_current_day,
	    case 
			  when extract(dow from start_time)=0 or extract(dow from start_time)=6 then 'weekend'
			  else 'weekday' end as day_type
		from total_bike_data
			   where company_name='bluebikes'
		group by day_type 
				 )
				 
--main query starts here
--extracting trips info for weekday n weekends
select  trips_current_day, day_type,
	    LAG(trips_current_day,1) over(  order by trips_current_day) as trips_previous,
		100 * ((trips_current_day-LAG(trips_current_day,1) over(order by trips_current_day))::float/trips_current_day::float) || '%' as growth_rate  
		from date_info	

--------------------baywheels-------------------

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),

-----extracting 
date_info as ( Select Count(bike_id) as trips_current_day,
	    case 
			  when extract(dow from start_time)=0 or extract(dow from start_time)=6 then 'weekend'
			  else 'weekday' end as day_type
		       from total_bike_data
			   where company_name='baywheels'
		group by day_type 
				 )

				 
--main query starts here
--extracting trips info for weekday n weekends
select  trips_current_day, day_type,
	    LAG(trips_current_day,1) over(  order by trips_current_day) as trips_previous,
		100 * ((trips_current_day-LAG(trips_current_day,1) over(order by trips_current_day))::float/trips_current_day::float) || '%' as growth_rate  
		from date_info

--------------------------------------------------------------------------------------------------------------------------------------





with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


bluebikes_station as (select  name, latitude, longtitude,id
					  from bluebikes_stations),

--- bike data for bluebikes and baywheels combined
---joining on start station_id


bb as (select bb.bike_id, bb.start_time, bb.end_time, bb.start_station_id, bb.end_station_id, bs.name as station_name,bs.latitude as start_latitude, bs.longtitude as start_longtitude, 
			be.latitude as end_latitude, be.longtitude as end_longtitude
			from bluebikes_data_combined as bb
			inner join bluebikes_station as bs on
			bb.start_station_id= bs.id
			inner join bluebikes_station as be on
			bb.end_station_id=be.id
			)
			
			select station_name,calculate_distance(start_latitude,start_longtitude,end_latitude,end_longtitude,'k') as distance
			from bb
			
----q4 What was the longest journey? What do we know about it?
--assumption  bluebikes_dataset for 2017 and 2018..and longest journey in two years. 

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


bluebikes_station as (select  name, latitude, longtitude,id
					  from bluebikes_stations),

--- bike data for bluebikes and baywheels combined
---joining on start station_id


bb as (select bb.bike_id, bb.start_time, bb.end_time, bb.start_station_id, bb.end_station_id, bs.name as start_station_name,be.name as end_station_name,bs.latitude as start_latitude, bs.longtitude as start_longtitude, 
			be.latitude as end_latitude, be.longtitude as end_longtitude, extract(year from bb.start_time) as year
			from bluebikes_data_combined as bb
			inner join bluebikes_station as bs on
			bb.start_station_id= bs.id
			inner join bluebikes_station as be on
			bb.end_station_id=be.id
			),
				
	dist as (		select year, start_station_name, end_station_name,calculate_distance(start_latitude,start_longtitude,end_latitude,end_longtitude,'k') as distance
			from bb)
			
			select year , max(distance) as maximum_distance
			from dist
			group by year
			order by maximum_distance desc
		
			
---q5 How often do bikes need to be relocated? for bluebikes_2017
with
expected_station_cte as(
select bike_id, start_time, end_time, start_station_id, end_station_id, LAG(end_station_id,1) over( order by bike_id desc, start_time asc, end_time asc) as expected_start_station
from bluebikes_2017
order by bike_id desc,start_time asc, end_time asc
	)
select count(*) from expected_station_cte
where start_station_id != expected_start_station


---baywheels-------------------
with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),


expected_station_cte as(
select bike_id, start_time, end_time, start_station_id, end_station_id, LAG(end_station_id,1) over( order by bike_id desc, start_time asc, end_time asc) as expected_start_station
from total_bike_data
	where company_name='baywheels'
order by bike_id desc,start_time asc, end_time asc
	)
select count(*) from expected_station_cte
where start_station_id != expected_start_station

------q6---
--How far is a typical journey? 
---assumptions- 2017 bluebikedat used...when days are weekends and categorised by month.. avg distance travelled per month.
with
----blubikes data for 2017 
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
),


bluebikes_station as (select  name, latitude, longtitude,id
					  from bluebikes_stations),

--- bike data for bluebikes and baywheels combined
---joining on start station_id

bb as (select bb.bike_id, bb.start_time, bb.end_time, bb.start_station_id, bb.end_station_id, bs.name as start_station_name,be.name as end_station_name,bs.latitude as start_latitude, bs.longtitude as start_longtitude, 
			be.latitude as end_latitude, be.longtitude as end_longtitude,extract(month from bb.start_time) as month,
	   case 
			  when extract(dow from bb.start_time)=0 or extract(dow from bb.start_time)=6 then 'weekend'
			  else 'weekday' end as day_type
			from bluebikes_data_combined as bb
			inner join bluebikes_station as bs on
			bb.start_station_id= bs.id
			inner join bluebikes_station as be on
			bb.end_station_id=be.id
			),
			
	dist as (		select day_type, month, start_station_name, end_station_name,calculate_distance(start_latitude,start_longtitude,end_latitude,end_longtitude,'k') as distance
			from bb)
			
			select month, avg(distance) as average_distance
			from dist
			where day_type='weekend'
			group by month
			order by average_distance desc
-------------------------------------------------------------------------------------------------------------------------------------
q6----2017 bluwbike data.. categorized as weekday or weekend.
with
----blubikes data for 2017 
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
),


bluebikes_station as (select  name, latitude, longtitude,id
					  from bluebikes_stations),

--- bike data for bluebikes and baywheels combined
---joining on start station_id

bb as (select bb.bike_id, bb.start_time, bb.end_time, bb.start_station_id, bb.end_station_id, bs.name as start_station_name,be.name as end_station_name,bs.latitude as start_latitude, bs.longtitude as start_longtitude, 
			be.latitude as end_latitude, be.longtitude as end_longtitude,
	   case 
			  when extract(dow from bb.start_time)=0 or extract(dow from bb.start_time)=6 then 'weekend'
			  else 'weekday' end as day_type
			from bluebikes_data_combined as bb
			inner join bluebikes_station as bs on
			bb.start_station_id= bs.id
			inner join bluebikes_station as be on
			bb.end_station_id=be.id
			),
			
	dist as (		select day_type, start_station_name, end_station_name,calculate_distance(start_latitude,start_longtitude,end_latitude,end_longtitude,'k') as distance
			from bb)
			
			select day_type, avg(distance) as average_distance
			from dist
			group by day_type
			order by average_distance desc
---------------------------------------------------------------------------------------------------
--q7- How does the weather affect bike hiring? (You will need to find a source of
--weather data).--
bluebikes data-- two year data divided into quaters


with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


season_info as (select  count(*) as no_of_trips,
	   		case 
			  when extract(month from start_time)= 1 and extract(month from start_time) <= 3 THEN 'WINTER'
			  when extract(month from start_time) >3 and extract(month from start_time)<= 6 THEN 'SPRING'
			  when extract(month from start_time) >6 and extract(month from start_time) <= 9 THEN 'SUMMER'
			  else 'AUTUMN' END AS Season
			from bluebikes_data_combined 
			group by  season
			order by no_of_trips DESC)
			
	select no_of_trips,  season
	from season_info
	order by season
			
------------------------------------------------------------------------
---for two organizations   (used for analysis)
with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined),


season_info as (select  count(*) as no_of_trips,company_name,
	   		case 
			  when extract(month from start_time)= 1 and extract(month from start_time) <= 3 THEN 'WINTER'
			  when extract(month from start_time) >3 and extract(month from start_time)<= 6 THEN 'SPRING'
			  when extract(month from start_time) >6 and extract(month from start_time) <= 9 THEN 'SUMMER'
			  else 'AUTUMN' END AS Season
			from total_bike_data
				group by  season,company_name
			order by no_of_trips DESC)
			
	select no_of_trips,  season, company_name
	from season_info
	order by season
-----------------------------------------------------------------
--q8 How effective are subscription systems?

with
----blubikes data for 2017 and  2018
bluebikes_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from bluebikes_2018 ),


----baywheels data for 2017 and 2018 
baywheels_data_combined as (
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2017
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type
from baywheels_2018 ),


--- bike data for bluebikes and baywheels combined

total_bike_data as (select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'bluebikes' as company_name
from bluebikes_data_combined
union
select bike_id,start_time,end_time,start_station_id,end_station_id,user_type,  'baywheels' as company_name
from baywheels_data_combined)


------ counting no of trips taken by customers and subscribes in two diff companies.
				select count(*) as no_of_trips,user_type,  company_name
				from total_bike_data
				group by user_type , company_name
				order by no_of_trips
				