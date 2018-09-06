### Conditon
- Connect to FRMS test database
- This sql is to generate area of forested, area of natural forest group by province
- Need to join plot table with district and province table to get province name
####

SELECT
	forested_area.NAME AS Province,
	SUM ( forested_area.area ) AS forested_area 
FROM
	(
SELECT
	plot.forest_type_code,
	plot.area,
	commune.commune_code,
	district.district_code,
	province.province_code,
	province.NAME 
FROM
	plot
	JOIN commune ON commune.commune_code = plot.commune_code
	JOIN district ON district.district_code = commune.district_code
	JOIN province ON province.province_code = district.province_code INTO Plot_complete 
WHERE
	forest_type_code >= 71 
	) INTO forested_area 
GROUP BY
	Province 
ORDER BY
	Province
