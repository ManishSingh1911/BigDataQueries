data = LOAD '/mnt/nyc_taxi_data_2014.csv' USING PigStorage(',');
records = FILTER data BY $0 != 'vendor_id';
nyc =  FOREACH  records  GENERATE $3 AS passenger_count, $12 AS fare_amount, $15 AS tip_amount;
nyctaxi = FILTER nyc BY  (passenger_count > 2 AND passenger_count < 10);
grouped = GROUP nyctaxi BY passenger_count;
last = FOREACH grouped GENERATE group, AVG(nyctaxi.fare_amount), AVG(nyctaxi.tip_amount);
DUMP last; 