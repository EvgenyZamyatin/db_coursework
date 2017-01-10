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
* check_person_rank_update_trigger -- Проверка того, что вышестоящий по званию командир не может быть у нижестоящщего в подчинении.
* check_eq_access_trigger -- Проверка того, что eq доступен для person.
* check_person_can_give_access_trigger -- Проверка на то, что person может выдать access на данный eq.
* check_eq_amount_trigger -- Проверка того, что имеющегося eq хватает для запроса.

## views:
* taken_equipment -- Для каждого eq количество взятых единиц.
* available_equipment -- Для каждого eq количество доступных единиц.
