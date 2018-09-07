#install.packages("RPostgreSQL")
#install.packages("sqldf")
#install.packages("dbplyr")
#install.packages("xlsx")
library(RPostgreSQL)
library(sqldf)
library(dplyr)
#library(dbplyr)
#library(xlsx)

setwd("c:/todel")

pw <- {
  "Friend5"
}
# loads the PostgreSQL driver
drv <- dbDriver("PostgreSQL")


con=dbConnect(drv, dbname = "data_forest",
                 host = "vnforest.gov.vn", port = 5433,
                 user = "postgres", password = pw)


#sqldf remember to set connection=con
#sqldf('select from where,connection=con)

forested=sqldf('SELECT forested_area.name as Province, sum(forested_area.area) as forested_area FROM (SELECT plot.forest_type_code,plot.area,commune.commune_code,district.district_code,province.province_code,province.NAME  FROM plot JOIN commune ON commune.commune_code = plot.commune_code JOIN district ON district.district_code = commune.district_code JOIN province ON province.province_code = district.province_code WHERE forest_type_code >= 71) as forested_area GROUP BY Province ORDER BY Province',connection=con)
natural = sqldf('SELECT natural_area.name as Province, sum(natural_area.area) as natural_area FROM (SELECT plot.forest_type_code,plot.area,commune.commune_code,district.district_code,province.province_code,province.NAME  FROM plot JOIN commune ON commune.commune_code = plot.commune_code JOIN district ON district.district_code = commune.district_code JOIN province ON province.province_code = district.province_code WHERE forest_type_code <= 59 and forest_type_code >0) as natural_area GROUP BY Province ORDER BY Province', connection=con)
plantation = sqldf('SELECT plantation_area.name as Province, sum(plantation_area.area) as plantation_area FROM (SELECT plot.forest_type_code,plot.area,commune.commune_code,district.district_code,province.province_code,province.NAME  FROM plot JOIN commune ON commune.commune_code = plot.commune_code JOIN district ON district.district_code = commune.district_code JOIN province ON province.province_code = district.province_code WHERE forest_type_code >= 60 and forest_type_code <=71) as plantation_area GROUP BY Province ORDER BY Province', connection=con)

result=left_join(forested, natural)
result=left_join(result,plantation)
View(result)

dbDisconnect(con)
