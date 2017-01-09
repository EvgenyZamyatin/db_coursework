-- Проверка того, что звания зарабатываются последовательно.
CREATE OR REPLACE FUNCTION check_rank_history_() RETURNS "trigger" AS $check_rank_history_$
    DECLARE
    old_rank INTEGER;
    BEGIN
        SELECT rank_id INTO old_rank FROM person WHERE person_id = NEW.person_id;
        IF old_rank - NEW.rank_id <> 1 OR old_rank - NEW.rank_id <> -1
            THEN RETURN NULL;
        END IF;
        RETURN NEW;
    END;
$check_rank_history_$ LANGUAGE plpgsql;

CREATE TRIGGER check_rank_history_trigger
BEFORE INSERT ON rank_history
FOR EACH ROW
EXECUTE PROCEDURE check_rank_history_();


-- Запрещено изменять rank_history
CREATE RULE forbid_update_rank_history AS ON UPDATE TO rank_history DO NOTHING;


-- Вместо вставки в rank_history делаем update person, а там дальше триггеры сами все делают.
CREATE RULE forbid_insert_rank_history AS ON INSERT TO rank_history DO INSTEAD
UPDATE person SET rank_id = NEW.rank_id WHERE person_id = NEW.person_id;


-- Функция, которая при изменении rank у person заносит изменения в rank_history.
CREATE OR REPLACE FUNCTION write_rank_history_() RETURNS "trigger" AS $write_rank_history_$
    BEGIN
        INSERT INTO rank_history (person_id, rank_id) VALUES (NEW.person_id, NEW.rank_id);
        IF FOUND
            THEN RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$write_rank_history_$ LANGUAGE plpgsql;

CREATE TRIGGER write_rank_history_trigger
BEFORE UPDATE ON person
FOR EACH ROW
EXECUTE PROCEDURE write_rank_history_();


-- Проверка того, что можно быть командиром не более чем у одного formation.
CREATE OR REPLACE FUNCTION check_unique_commander_() RETURNS "trigger" AS $check_unique_commander_$
    BEGIN
        IF NEW.commander_id IS NULL
            THEN RETURN NEW;
        END IF;
        IF EXISTS (SELECT commander_id FROM army_formation
                   WHERE  commander_id = NEW.commander_id)
            THEN RETURN NULL;
        END IF;
        RETURN NEW;
    END;
$check_unique_commander_$ LANGUAGE plpgsql;

CREATE TRIGGER check_unique_commander_trigger
BEFORE INSERT OR UPDATE ON army_formation
FOR EACH ROW
EXECUTE PROCEDURE check_unique_commander_();


-- Проверка того, что вышестоящий по званию командир не может быть у нижестоящщего в подчинении.
CREATE OR REPLACE FUNCTION check_army_formation_() RETURNS "trigger" AS $check_army_formation_$
    DECLARE
    new_rank INTEGER;

    BEGIN
        IF NEW.commander_id IS NULL
            THEN RETURN NEW;
        END IF;

        SELECT rank_id INTO new_rank FROM person WHERE person_id = NEW.commander_id;

        IF EXISTS (SELECT commander_id, parent_id, formation_id FROM army_formation
                   WHERE
                       (parent_id = NEW.formation_id
                   AND (SELECT rank_id FROM person
                        WHERE person_id = commander_id
                        AND   rank_id > new_rank))
                   OR
                       (formation_id = NEW.parent_id
                   AND (SELECT rank_id FROM person
                        WHERE person_id = commander_id
                        AND   rank_id < new_rank)))
            THEN RETURN NULL;
        END IF;

        RETURN NEW;
    END;
$check_army_formation_$ LANGUAGE plpgsql;

CREATE TRIGGER check_army_formation_trigger
BEFORE INSERT OR UPDATE ON army_formation
FOR EACH ROW
EXECUTE PROCEDURE check_army_formation_();

CREATE OR REPLACE FUNCTION check_person_rank_update_() RETURNS "trigger" AS $check_person_rank_update_$
    BEGIN
        IF EXISTS (SELECT formation_id AS f, parent_id AS p
                   WHERE commander_id = NEW.person_id
                   AND EXISTS (SELECT commander_id, parent_id, formation_id FROM army_formation
                               WHERE
                                   (parent_id = f
                               AND (SELECT rank_id FROM person
                                    WHERE person_id = commander_id
                                    AND   rank_id > new_rank))
                               OR
                                   (formation_id = p
                               AND (SELECT rank_id FROM person
                                    WHERE person_id = commander_id
                                    AND   rank_id < new_rank))))
            THEN RETURN NULL;
        END IF;
        RETURN NEW;
    END;
$check_person_rank_update_$ LANGUAGE plpgsql;

CREATE TRIGGER check_person_rank_update_trigger
BEFORE UPDATE ON person
FOR EACH ROW WHEN (OLD.rank_id IS DISTINCT FROM NEW.rank_id)
EXECUTE PROCEDURE check_person_rank_update_();


-- Проверка того, что equipment доступно для person.
CREATE OR REPLACE FUNCTION check_eq_access_() RETURNS "trigger" AS $check_eq_access_$
    BEGIN
        IF (SELECT rank_id FROM person WHERE person_id = NEW.person_id) >= (SELECT required_rank FROM equipment WHERE eq_id = NEW.eq_id)
            OR EXISTS (SELECT to_person_id, eq_id, inspiration_date FROM additional_equipment_access
                       WHERE person_id = NEW.person_id
                       AND   eq_id = NEW.eq_id
                       AND   inspiration_date > NEW.take_date)
            THEN RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$check_eq_access_$ LANGUAGE plpgsql;

CREATE TRIGGER check_eq_access_trigger
BEFORE INSERT ON equipment_use_history
FOR EACH ROW
EXECUTE PROCEDURE check_eq_access_();


-- Проверка на то, что person может выдать access на данный eq.
CREATE OR REPLACE FUNCTION check_person_can_give_access_() RETURNS "trigger" AS $check_person_can_give_access_$
    BEGIN
        IF (SELECT rank_id FROM person WHERE person_id = NEW.from_person_id) >= (SELECT required_rank FROM equipment WHERE eq_id = NEW.eq_id)
            THEN RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$check_person_can_give_access_$ LANGUAGE plpgsql;

CREATE TRIGGER check_person_can_give_access_trigger
BEFORE INSERT ON additional_equipment_access
FOR EACH ROW
EXECUTE PROCEDURE check_person_can_give_access_();


-- Проверка того, что имеющегося eq хватает для запроса.
CREATE OR REPLACE FUNCTION check_eq_amount_() RETURNS "trigger" AS $check_eq_amount_$
    BEGIN
        IF (SELECT total_available FROM available_equipment WHERE eq_id = NEW.eq_id) >= NEW.taken_amount
            THEN RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$check_eq_amount_$ LANGUAGE plpgsql;

CREATE TRIGGER check_eq_amount_trigger
BEFORE INSERT ON equipment_use_history
FOR EACH ROW
EXECUTE PROCEDURE check_eq_amount_();
