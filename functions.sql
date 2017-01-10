-- Функция, позволяющая взять eq.
CREATE OR REPLACE FUNCTION take_equipment(p INT, e INT, a INT) RETURNS INT AS $take_equipment$
    DECLARE
    res INTEGER;
    BEGIN
        INSERT INTO equipment_use_history (person_id, eq_id, taken_amount) VALUES (p, e, a)
        RETURNING event_id INTO res;
        IF FOUND THEN
            RETURN res;
        END IF;
        RETURN -1;
    END;
$take_equipment$ LANGUAGE plpgsql;


-- Функция, позволяющая вернуть eq.
CREATE OR REPLACE FUNCTION return_equipment(e INT, a INT) RETURNS BOOLEAN AS $return_equipment$
    DECLARE
    eeq_id INTEGER;
    diff INTEGER;
    BEGIN
        UPDATE equipment_use_history SET return_date = NOW(), returned_amount = a WHERE event_id = e;
        IF NOT FOUND THEN RETURN FALSE;
        END IF;
        SELECT equipment_use_history.eq_id INTO eeq_id FROM equipment_use_history WHERE event_id = e;
        SELECT returned_amount - taken_amount INTO diff FROM equipment_use_history WHERE event_id = e;
        UPDATE equipment SET eq_amount = eq_amount + diff WHERE equipment.eq_id = eeq_id;
        RETURN TRUE;
    END;
$return_equipment$ LANGUAGE plpgsql;


-- Функция, позволяющая выдать разрешение на получение eq.
CREATE OR REPLACE FUNCTION give_access(fp INT, tp INT, e INT, d INTERVAL) RETURNS BOOLEAN AS $give_access$
    BEGIN
        INSERT INTO additional_equipment_access (from_person_id, to_person_id, eq_id, inspiration_date) VALUES (fp, tp, e, NOW() + d);
        RETURN FOUND;
    END;
$give_access$ LANGUAGE plpgsql;


-- Функция, позволяющая повысить person.
CREATE OR REPLACE FUNCTION give_raise(p INT, up BOOLEAN) RETURNS BOOLEAN AS $give_raise$
    BEGIN
        IF UP THEN
            UPDATE person SET rank_id = rank_id + 1 WHERE person_id = p;
        ELSE
            UPDATE person SET rank_id = rank_id - 1 WHERE person_id = p;
        END IF;
        RETURN FOUND;
    END;
$give_raise$ LANGUAGE plpgsql;


-- Функция, позваляющая узнать, какой eq на руках у person.
CREATE OR REPLACE FUNCTION taken_eq_by(p INT) RETURNS SETOF equipment_use_history AS $taken_eq_by$
    BEGIN
        RETURN QUERY SELECT * FROM equipment_use_history WHERE person_id = p;
    END;
$taken_eq_by$ LANGUAGE plpgsql;


-- Функция, позволяющая узнать состав подразделения.
CREATE OR REPLACE FUNCTION composition_unit(f INT) RETURNS SETOF army_formation AS $composition_unit$
    BEGIN
        RETURN QUERY WITH RECURSIVE r AS (
            SELECT * FROM army_formation WHERE formation_id = f
            UNION
            SELECT army_formation.* FROM army_formation, r WHERE army_formation.parent_id = r.formation_id
        )
        SELECT * FROM r;
    END;
$composition_unit$ LANGUAGE plpgsql;


-- Функция, позволяющая узнать подразделения без командира.
CREATE OR REPLACE FUNCTION null_commanders() RETURNS SETOF army_formation AS $null_commanders$
    BEGIN
        RETURN QUERY SELECT * FROM army_formation WHERE commander_id IS NULL;
    END;
$null_commanders$ LANGUAGE plpgsql;
