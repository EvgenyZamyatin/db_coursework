dropdb army1
createdb army1
psql -d army1 -f tables.sql
psql -d army1 -f views.sql
psql -d army1 -f triggers.sql
psql -d army1 -f fill.sql
