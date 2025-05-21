WITH pre_select AS (
  SELECT
    p.*,
    g.name as city
  FROM `totemic-client-447220-r1.openweather_etl.pollution_raw` p
  LEFT JOIN `totemic-client-447220-r1.openweather_etl.geo_raw` g
  ON ROUND(p.coord.lon, 2) = ROUND(g.lon, 2) AND ROUND(p.coord.lat, 2)=ROUND(g.lat, 2)
)
SELECT
  city,
  `list`[SAFE_OFFSET(0)].main.aqi as ,
  `list`[SAFE_OFFSET(0)].components.co as co,
  `list`[SAFE_OFFSET(0)].components.`no` as no,
  `list`[SAFE_OFFSET(0)].components.no2 as no2,
  `list`[SAFE_OFFSET(0)].components.o3 as o3,
  `list`[SAFE_OFFSET(0)].components.so2 as so2,
  `list`[SAFE_OFFSET(0)].components.pm2_5 as pm2_5,
  `list`[SAFE_OFFSET(0)].components.pm10 as pm10,
  `list`[SAFE_OFFSET(0)].components.nh3 as nh3,
  `list`[SAFE_OFFSET(0)].dt as dt
FROM pre_select
QUALIFY ROW_NUMBER() OVER (PARTITION BY city ORDER BY `list`[SAFE_OFFSET(0)].dt DESC) = 1