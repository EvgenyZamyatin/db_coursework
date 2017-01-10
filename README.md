# db_coursework

## tables:
* additional_equipment_access
* army_formation
* equipment
* equipment_use_history
* person
* rank
* rank_history

## triggers:
* check_rank_history_trigger -- Проверка того, что звания зарабатываются последовательно.
* write_rank_history_trigger -- Функция, которая при изменении rank у person заносит изменения в rank_history.
* check_unique_commander_trigger -- Проверка того, что можно быть командиром не более чем у одного formation.
* check_person_rank_update_trigger -- Проверка того, что вышестоящий по званию командир не может быть у нижестоящего в подчинении.
* check_eq_access_trigger -- Проверка того, что eq доступен для person.
* check_person_can_give_access_trigger -- Проверка на то, что person может выдать access на данный eq.
* check_eq_amount_trigger -- Проверка того, что имеющегося eq хватает для запроса.
* check_army_formation_type_trigger -- Проверка того, что тип родителя у formation больше.


## views:
* taken_equipment -- Для каждого eq количество взятых единиц.
* available_equipment -- Для каждого eq количество доступных единиц.


## functions:
* take_equipment(p INT, e INT, a INT) -- Функция, позволяющая взять eq.
* return_equipment(e INT, a INT) -- Функция, позволяющая вернуть eq.
* give_access(fp INT, tp INT, e INT, d INTERVAL) -- Функция, позволяющая выдать разрешение на получение eq.
* give_raise(p INT, up BOOLEAN) -- Функция, позволяющая повысить person.
* taken_eq_by(p INT) -- Функция, позволяющая узнать, какой eq на руках у person.
* composition_unit(f INT) -- Функция, позволяющая узнать состав подразделения.
* null_commanders() -- Функция, позволяющая узнать подразделения без командира.
* persons_by_time(a TIMESTAMP, b TIMESTAMP) -- Функция, позволяющая узнать, кто служил в определенный промежуток времени.


## indexes:
* person_time_index ON person(registered ASC, unregistered ASC);
* person_id_index ON person(person_id);
* rank_history_time_index ON rank_history(event_date ASC);
* rank_history_id_index ON rank_history(event_id);
* rank_id_index ON rank(rank_id);
* equipment_id_index ON equipment(eq_id);
* equipment_use_history_id_index ON equipment_use_history(event_id);
* equipment_use_history_return_date_index ON equipment_use_history(return_date ASC, take_date ASC);
* additional_equipment_access_id_index ON additional_equipment_access(event_id);
* additional_equipment_access_tpid_index ON additional_equipment_access(to_person_id, eq_id);
* additional_equipment_access_time_index ON additional_equipment_access(inspiration_date ASC);
* army_formation_parent_id ON army_formation(parent_id);
* army_formation_commander_id ON army_formation(commander_id);
