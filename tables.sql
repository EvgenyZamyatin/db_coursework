CREATE TABLE additional_equipment_access
(
    inspiration_date TIMESTAMP NOT NULL,
    from_person_id INTEGER NOT NULL,
    eq_id INTEGER NOT NULL,
    to_person_id INTEGER NOT NULL,
    event_id SERIAL NOT NULL PRIMARY KEY
);

CREATE TYPE FORMATIONS AS ENUM ('F0', 'F1', 'F2', 'F3', 'F4');

CREATE TABLE army_formation
(
    formation_id INTEGER PRIMARY KEY NOT NULL,
    fromation_type FORMATIONS NOT NULL,
    formation_name VARCHAR(100) NOT NULL,
    commander_id INTEGER,
    parent_id INTEGER NOT NULL
);

CREATE TABLE equipment
(
    eq_id SERIAL PRIMARY KEY NOT NULL,
    eq_name VARCHAR(100) NOT NULL,
    eq_amount INTEGER NOT NULL,
    required_rank INTEGER NOT NULL
);

CREATE TABLE equipment_use_history
(
    take_date TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE DEFAULT 'infinity'::timestamp with time zone NOT NULL,
    taken_amount INTEGER NOT NULL,
    returned_amount INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    eq_id INTEGER NOT NULL,
    event_id SERIAL PRIMARY KEY NOT NULL
);

CREATE TABLE person
(
    person_id INTEGER PRIMARY KEY NOT NULL,
    person_name VARCHAR(100) NOT NULL,
    registered TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    unregistered TIMESTAMP WITH TIME ZONE DEFAULT 'infinity'::timestamp with time zone NOT NULL,
    rank_id INTEGER NOT NULL
);

CREATE TABLE rank
(
    rank_id INTEGER PRIMARY KEY NOT NULL,
    rank_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE rank_history
(
    event_date TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    rank_id INTEGER NOT NULL,
    person_id INTEGER NOT NULL,
    event_id SERIAL PRIMARY KEY NOT NULL
);

ALTER TABLE additional_equipment_access ADD CONSTRAINT additional_equipment_access_person_person_id_fk FOREIGN KEY (from_person_id) REFERENCES person (person_id);
ALTER TABLE additional_equipment_access ADD CONSTRAINT additional_equipment_access_equipment_eq_id_fk FOREIGN KEY (eq_id) REFERENCES equipment (eq_id);
ALTER TABLE additional_equipment_access ADD CONSTRAINT additional_equipment_access_person__fk1 FOREIGN KEY (to_person_id) REFERENCES person (person_id);

ALTER TABLE army_formation ADD CONSTRAINT army_formation_person_person_id_fk FOREIGN KEY (commander_id) REFERENCES person (person_id);
ALTER TABLE army_formation ADD CONSTRAINT army_formation_army_formation_formation_id_fk FOREIGN KEY (parent_id) REFERENCES army_formation (formation_id);

ALTER TABLE equipment_use_history ADD CONSTRAINT equipment_use_history_person_person_id_fk FOREIGN KEY (person_id) REFERENCES person (person_id);
ALTER TABLE equipment_use_history ADD CONSTRAINT equipment_use_history_equipment_eq_id_fk FOREIGN KEY (eq_id) REFERENCES equipment (eq_id);

ALTER TABLE person ADD CONSTRAINT person_rank_rank_id_fk FOREIGN KEY (rank_id) REFERENCES rank (rank_id);

ALTER TABLE rank_history ADD CONSTRAINT rank_history_rank_rank_id_fk FOREIGN KEY (rank_id) REFERENCES rank (rank_id);
ALTER TABLE rank_history ADD CONSTRAINT rank_history_person_person_id_fk FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE equipment ADD CONSTRAINT equipment_required_rank_rank_id_fk FOREIGN KEY (required_rank) REFERENCES rank (rank_id);
