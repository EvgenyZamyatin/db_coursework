dropdb army1
createdb army1
echo "=== CREATE TABLES ==="
psql -d army1 -f tables.sql
echo "=== CREATE VIEWS ==="
psql -d army1 -f views.sql
echo "=== CREATE TRIGGERS ==="
psql -d army1 -f triggers.sql
echo "=== CREATE FUNCTIONS ==="
psql -d army1 -f functions.sql
echo "=== CREATE INDEXES ==="
psql -d army1 -f indexes.sql
echo "=== CREATE RECORDS ==="
psql -d army1 -f fill.sql
