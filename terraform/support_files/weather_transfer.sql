WITH pre_select AS (
  SELECT
    w.*,
    g.name as city
  FROM `totemic-client-447220-r1.openweather_etl.weather_raw` w
  LEFT JOIN `totemic-client-447220-r1.openweather_etl.geo_raw` g
  ON ROUND(w.coord.lon, 2) = ROUND(g.lon, 2) AND ROUND(w.coord.lat, 2)=ROUND(g.lat, 2)
)
SELECT
  city,
  coord.lon as lon,
  coord.lat as lat,
  ROUND(main.temp - 273.15, 2) as temperature,
  ROUND(main.feels_like - 273.15, 2) as feels_like_temperature,
  ROUND(main.temp_max - 273.15, 2) as max_temperature,
  ROUND(main.temp_min - 273.15, 2) as min_temperature,
  main.humidity as humidity,
  main.pressure as pressure,
  main.grnd_level as ground_level,
  main.sea_level as sea_level,
  dt as dt
FROM pre_select
QUALIFY ROW_NUMBER() OVER (PARTITION BY city ORDER BY dt DESC) = 1