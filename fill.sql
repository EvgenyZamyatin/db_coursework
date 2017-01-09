INSERT INTO rank (rank_id, rank_name) VALUES
(0, 'R0'),
(1, 'R1'),
(2, 'R2'),
(3, 'R3'),
(4, 'R4'),
(5, 'R5');

INSERT INTO person (person_id, person_name, registered, rank_id) VALUES
(0, 'A0', NOW(), 0),
(1, 'A1', NOW(), 0),
(2, 'A2', NOW(), 0),
(3, 'A3', NOW(), 0),
(4, 'A4', NOW(), 0),
(5, 'A5', NOW(), 0),
(6, 'B0', NOW(), 1),
(7, 'B1', NOW(), 1),
(8, 'B2', NOW(), 1),
(9, 'B3', NOW(), 1),
(10, 'B4', NOW(), 1),
(11, 'C0', NOW(), 2),
(12, 'C1', NOW(), 2),
(13, 'C2', NOW(), 2),
(14, 'C3', NOW(), 2),
(15, 'D0', NOW(), 3),
(16, 'D1', NOW(), 3),
(17, 'D2', NOW(), 3),
(18, 'E0', NOW(), 4),
(19, 'E1', NOW(), 4),
(20, 'F0', NOW(), 5);

INSERT INTO equipment (eq_name, eq_amount, required_rank) VALUES
('A', 100, 0),
('B', 100, 1),
('C', 100, 2),
('D', 100, 3),
('E', 100, 4),
('F', 100, 5),
('A1', 1, 0),
('B1', 1, 1),
('C1', 1, 2),
('D1', 1, 3),
('E1', 1, 4),
('F1', 1, 5);


INSERT INTO army_formation (formation_id, fromation_type, formation_name, commander_id, parent_id) VALUES
(0, 'F4', 'DIVISION', 20, 0),

(1, 'F3', 'BATTERY_0', 18, 0),

(2, 'F2', 'PLAT_1', 16, 1),
(3, 'F2', 'PLAT_2', 11, 1),

(4, 'F1', 'SQUAD_1', 12, 2),
(5, 'F1', 'SQUAD_2', 6, 2),
(6, 'F1', 'SQUAD_3', 7, 3),
(7, 'F1', 'SQUAD_4', 0, 3),

(8, 'F0', 'UNIT_1', 1, 4),
(9, 'F0', 'UNIT_2', 2, 5),
(10, 'F0', 'UNIT_3', 3, 6),
(11, 'F0', 'UNIT_4', 4, 7);
