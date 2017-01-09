CREATE VIEW taken_equipment AS
SELECT eq_id, COUNT(return_date > NOW()) AS total_taken FROM equipment_use_history
GROUP BY eq_id;

CREATE VIEW available_equipment AS
SELECT equipment.eq_id, eq_amount - coalesce(total_taken, 0) AS total_available
FROM equipment LEFT OUTER JOIN taken_equipment ON equipment.eq_id = taken_equipment.eq_id;
