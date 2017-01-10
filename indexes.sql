CREATE INDEX person_time_index ON person(registered ASC, unregistered ASC);
CREATE UNIQUE INDEX person_id_index ON person(person_id);

CREATE INDEX rank_history_time_index ON rank_history(event_date ASC);
CREATE UNIQUE INDEX rank_history_id_index ON rank_history(event_id);

CREATE UNIQUE INDEX rank_id_index ON rank(rank_id);

CREATE UNIQUE INDEX equipment_id_index ON equipment(eq_id);

CREATE UNIQUE INDEX equipment_use_history_id_index ON equipment_use_history(event_id);
CREATE INDEX equipment_use_history_return_date_index ON equipment_use_history(return_date ASC, take_date ASC);

CREATE UNIQUE INDEX additional_equipment_access_id_index ON additional_equipment_access(event_id);
CREATE INDEX additional_equipment_access_tpid_index ON additional_equipment_access(to_person_id, eq_id);
CREATE INDEX additional_equipment_access_time_index ON additional_equipment_access(inspiration_date ASC);

CREATE INDEX army_formation_parent_id ON army_formation(parent_id);
CREATE INDEX army_formation_commander_id ON army_formation(commander_id);
