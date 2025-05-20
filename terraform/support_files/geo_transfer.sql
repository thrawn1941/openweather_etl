  SELECT
    name as city,
    ANY_VALUE(lat) as lat,
    ANY_VALUE(lon) as lon,
    ANY_VALUE(country) as country,
    ANY_VALUE(state) as state
  FROM `totemic-client-447220-r1.openweather_etl.geo_raw`
  GROUP BY name