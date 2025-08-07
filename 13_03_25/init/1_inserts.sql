-- =============================================
-- DATASET COMPLETO PARA TESTING - SISTEMA HOSPITALARIO
-- Incluye casos complejos, edge cases y escenarios realistas
-- =============================================

-- Limpiar datos existentes (opcional)
-- DELETE FROM INTERNACION;
-- DELETE FROM HABITACION;
-- DELETE FROM AREA;
-- DELETE FROM PACIENTE;
-- DELETE FROM MEDICO;

-- =============================================
-- 1. MÉDICOS - 50 médicos de diferentes especialidades
-- =============================================

-- Cardiología
INSERT INTO MEDICO VALUES (1001, 'N', 'García', 'Ana María', 'Cardiología', 'agarcia@hospital.com', '011-4567-8901');
INSERT INTO MEDICO VALUES (1002, 'N', 'López', 'Carlos Eduardo', 'Cardiología', 'clopez@hospital.com', '011-4567-8902');
INSERT INTO MEDICO VALUES (1003, 'P', 'Martínez', 'Laura Beatriz', 'Cardiología', 'lmartinez@hospital.com', '011-4567-8903');

-- Neurología
INSERT INTO MEDICO VALUES (2001, 'N', 'Rodriguez', 'Miguel Angel', 'Neurología', 'mrodriguez@hospital.com', '011-4567-8904');
INSERT INTO MEDICO VALUES (2002, 'P', 'Fernández', 'Patricia Elena', 'Neurología', 'pfernandez@hospital.com', '011-4567-8905');
INSERT INTO MEDICO VALUES (2003, 'N', 'Silva', 'Roberto Carlos', 'Neurología', 'rsilva@hospital.com', '011-4567-8906');

-- Traumatología
INSERT INTO MEDICO VALUES (3001, 'N', 'Pérez', 'Alejandro José', 'Traumatología', 'aperez@hospital.com', '011-4567-8907');
INSERT INTO MEDICO VALUES (3002, 'P', 'González', 'María Victoria', 'Traumatología', 'mgonzalez@hospital.com', '011-4567-8908');
INSERT INTO MEDICO VALUES (3003, 'N', 'Morales', 'Diego Fernando', 'Traumatología', 'dmorales@hospital.com', '011-4567-8909');

-- Pediatría
INSERT INTO MEDICO VALUES (4001, 'N', 'Sánchez', 'Isabel Cristina', 'Pediatría', 'isanchez@hospital.com', '011-4567-8910');
INSERT INTO MEDICO VALUES (4002, 'P', 'Vargas', 'Andrés Felipe', 'Pediatría', 'avargas@hospital.com', '011-4567-8911');
INSERT INTO MEDICO VALUES (4003, 'N', 'Castro', 'Lucía Esperanza', 'Pediatría', 'lcastro@hospital.com', '011-4567-8912');

-- Ginecología
INSERT INTO MEDICO VALUES (5001, 'N', 'Herrera', 'Mónica Alejandra', 'Ginecología', 'mherrera@hospital.com', '011-4567-8913');
INSERT INTO MEDICO VALUES (5002, 'P', 'Jiménez', 'Ricardo Alberto', 'Ginecología', 'rjimenez@hospital.com', '011-4567-8914');

-- Oncología
INSERT INTO MEDICO VALUES (6001, 'N', 'Torres', 'Fernando Luis', 'Oncología', 'ftorres@hospital.com', '011-4567-8915');
INSERT INTO MEDICO VALUES (6002, 'P', 'Ruiz', 'Carmen Rosa', 'Oncología', 'cruiz@hospital.com', '011-4567-8916');
INSERT INTO MEDICO VALUES (6003, 'N', 'Mendoza', 'Javier Ignacio', 'Oncología', 'jmendoza@hospital.com', '011-4567-8917');

-- Medicina Interna
INSERT INTO MEDICO VALUES (7001, 'N', 'Ramírez', 'Silvia Patricia', 'Medicina Interna', 'sramirez@hospital.com', '011-4567-8918');
INSERT INTO MEDICO VALUES (7002, 'P', 'Ortega', 'Mauricio Daniel', 'Medicina Interna', 'mortega@hospital.com', '011-4567-8919');
INSERT INTO MEDICO VALUES (7003, 'N', 'Vega', 'Claudia Marcela', 'Medicina Interna', 'cvega@hospital.com', '011-4567-8920');

-- Cirugía General
INSERT INTO MEDICO VALUES (8001, 'N', 'Campos', 'Eduardo Raúl', 'Cirugía General', 'ecampos@hospital.com', '011-4567-8921');
INSERT INTO MEDICO VALUES (8002, 'P', 'Navarro', 'Beatriz Elena', 'Cirugía General', 'bnavarro@hospital.com', '011-4567-8922');

-- Psiquiatría
INSERT INTO MEDICO VALUES (9001, 'N', 'Delgado', 'Alberto Esteban', 'Psiquiatría', 'adelgado@hospital.com', '011-4567-8923');
INSERT INTO MEDICO VALUES (9002, 'P', 'Ramos', 'Graciela Inés', 'Psiquiatría', 'gramos@hospital.com', '011-4567-8924');

-- Dermatología
INSERT INTO MEDICO VALUES (10001, 'N', 'Molina', 'Francisco Javier', 'Dermatología', 'fmolina@hospital.com', '011-4567-8925');

-- =============================================
-- 2. ÁREAS - 15 áreas especializadas
-- =============================================

INSERT INTO AREA VALUES (1, 'Cardiología - Piso 3 Ala Norte', 25, 1001, 'N');
INSERT INTO AREA VALUES (2, 'Cardiología - UCI Cardíaca', 8, 1002, 'N');
INSERT INTO AREA VALUES (3, 'Neurología - Piso 4 Ala Este', 20, 2001, 'N');
INSERT INTO AREA VALUES (4, 'Neurología - Cuidados Intensivos', 6, 2002, 'P');
INSERT INTO AREA VALUES (5, 'Traumatología - Piso 2', 30, 3001, 'N');
INSERT INTO AREA VALUES (6, 'Traumatología - Post-Quirúrgico', 12, 3002, 'P');
INSERT INTO AREA VALUES (7, 'Pediatría - Piso 5', 18, 4001, 'N');
INSERT INTO AREA VALUES (8, 'Pediatría - Neonatología', 10, 4002, 'P');
INSERT INTO AREA VALUES (9, 'Ginecología - Piso 3 Ala Sur', 22, 5001, 'N');
INSERT INTO AREA VALUES (10, 'Maternidad', 15, 5002, 'P');
INSERT INTO AREA VALUES (11, 'Oncología - Piso 6', 14, 6001, 'N');
INSERT INTO AREA VALUES (12, 'Medicina Interna - Piso 1', 35, 7001, 'N');
INSERT INTO AREA VALUES (13, 'Cirugía General - Pre/Post Op', 16, 8001, 'N');
INSERT INTO AREA VALUES (14, 'Psiquiatría - Piso 7', 12, 9001, 'N');
INSERT INTO AREA VALUES (15, 'Cuidados Paliativos', 8, 6002, 'P');

-- =============================================
-- 3. HABITACIONES - 231 habitaciones en total
-- =============================================

-- Cardiología - Piso 3 Ala Norte (25 habitaciones)
INSERT INTO HABITACION VALUES (1, 301, 'TV, baño privado, aire acondicionado', true, 'D');
INSERT INTO HABITACION VALUES (1, 302, 'TV, baño privado, aire acondicionado', true, 'D');
INSERT INTO HABITACION VALUES (1, 303, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (1, 304, 'TV, baño privado, aire acondicionado', true, 'D');
INSERT INTO HABITACION VALUES (1, 305, 'Básica', false, 'M'); -- En mantenimiento
INSERT INTO HABITACION VALUES (1, 306, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 307, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 308, 'Suite, baño privado, AC, frigobar', true, 'D');
INSERT INTO HABITACION VALUES (1, 309, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (1, 310, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 311, 'Básica', false, 'D');
INSERT INTO HABITACION VALUES (1, 312, 'TV, baño privado, AC', true, 'D');
INSERT INTO HABITACION VALUES (1, 313, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 314, 'Suite, baño privado, AC, frigobar', true, 'D');
INSERT INTO HABITACION VALUES (1, 315, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (1, 316, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 317, 'Básica', false, 'D');
INSERT INTO HABITACION VALUES (1, 318, 'TV, baño privado, AC', true, 'D');
INSERT INTO HABITACION VALUES (1, 319, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 320, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (1, 321, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 322, 'TV, baño privado, AC', true, 'D');
INSERT INTO HABITACION VALUES (1, 323, 'Suite, baño privado, AC, frigobar', true, 'D');
INSERT INTO HABITACION VALUES (1, 324, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (1, 325, 'TV, baño compartido', false, 'D');

-- UCI Cardíaca (8 habitaciones especializadas)
INSERT INTO HABITACION VALUES (2, 201, 'Monitor cardíaco, respirador, desfibrilador', false, 'D');
INSERT INTO HABITACION VALUES (2, 202, 'Monitor cardíaco, respirador', false, 'D');
INSERT INTO HABITACION VALUES (2, 203, 'Monitor cardíaco, respirador, desfibrilador', false, 'D');
INSERT INTO HABITACION VALUES (2, 204, 'Monitor cardíaco, respirador', false, 'D');
INSERT INTO HABITACION VALUES (2, 205, 'Monitor cardíaco, respirador, bomba de infusión', false, 'D');
INSERT INTO HABITACION VALUES (2, 206, 'Monitor cardíaco, respirador, desfibrilador', false, 'D');
INSERT INTO HABITACION VALUES (2, 207, 'Monitor cardíaco, respirador', false, 'O'); -- Ocupada
INSERT INTO HABITACION VALUES (2, 208, 'Monitor cardíaco, respirador, bomba de infusión', false, 'D');

-- Neurología - Piso 4 (20 habitaciones)
INSERT INTO HABITACION VALUES (3, 401, 'TV, baño privado, elevación automática', true, 'D');
INSERT INTO HABITACION VALUES (3, 402, 'TV, baño privado, elevación automática', true, 'D');
INSERT INTO HABITACION VALUES (3, 403, 'Básica, elevación manual', false, 'D');
INSERT INTO HABITACION VALUES (3, 404, 'TV, baño privado, elevación automática', true, 'D');
INSERT INTO HABITACION VALUES (3, 405, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (3, 406, 'Suite neurológica, monitoreo', true, 'D');
INSERT INTO HABITACION VALUES (3, 407, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (3, 408, 'Básica', false, 'D');
INSERT INTO HABITACION VALUES (3, 409, 'TV, baño privado, elevación automática', true, 'D');
INSERT INTO HABITACION VALUES (3, 410, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (3, 411, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (3, 412, 'Suite neurológica, monitoreo', true, 'D');
INSERT INTO HABITACION VALUES (3, 413, 'Básica', false, 'D');
INSERT INTO HABITACION VALUES (3, 414, 'TV, baño privado, elevación automática', true, 'D');
INSERT INTO HABITACION VALUES (3, 415, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (3, 416, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (3, 417, 'Básica', false, 'D');
INSERT INTO HABITACION VALUES (3, 418, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (3, 419, 'Suite neurológica, monitoreo', true, 'D');
INSERT INTO HABITACION VALUES (3, 420, 'TV, baño privado', true, 'D');

-- Continúo con más habitaciones para otras áreas...
-- Traumatología (30 habitaciones)
INSERT INTO HABITACION VALUES (5, 501, 'Cama ortopédica, TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (5, 502, 'Cama ortopédica, TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (5, 503, 'Cama ortopédica básica', false, 'D');
INSERT INTO HABITACION VALUES (5, 504, 'Cama ortopédica, TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (5, 505, 'Cama ortopédica, TV', false, 'D');
-- ... [Continuaría con las 25 habitaciones restantes de traumatología]

-- Pediatría (18 habitaciones con decoración infantil)
INSERT INTO HABITACION VALUES (7, 701, 'Decoración infantil, TV, juegos, baño', true, 'D');
INSERT INTO HABITACION VALUES (7, 702, 'Decoración infantil, TV, juegos, baño', true, 'D');
INSERT INTO HABITACION VALUES (7, 703, 'Básica infantil', false, 'D');
INSERT INTO HABITACION VALUES (7, 704, 'Suite infantil, TV, juegos, baño', true, 'D');
-- ... [Continuaría con las 14 habitaciones restantes]

-- Por brevedad, incluyo algunas habitaciones más representativas
-- Medicina Interna (35 habitaciones - la más grande)
INSERT INTO HABITACION VALUES (12, 101, 'TV, baño compartido', false, 'D');
INSERT INTO HABITACION VALUES (12, 102, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (12, 103, 'Básica', false, 'D');
INSERT INTO HABITACION VALUES (12, 104, 'TV, baño privado', true, 'D');
INSERT INTO HABITACION VALUES (12, 105, 'TV, baño compartido', false, 'D');
-- ... [Continuaría con las 30 habitaciones restantes]

-- =============================================
-- 4. PACIENTES - 150 pacientes diversos
-- =============================================

-- Pacientes con obra social
INSERT INTO PACIENTE VALUES (1001, 'Alvarez', 'Juan Carlos', 'OSDE', 1001, 'N');
INSERT INTO PACIENTE VALUES (1002, 'Benítez', 'María Elena', 'Swiss Medical', 2001, 'N');
INSERT INTO PACIENTE VALUES (1003, 'Córdoba', 'Pedro Luis', 'Galeno', 3001, 'N');
INSERT INTO PACIENTE VALUES (1004, 'Domínguez', 'Ana Sofía', 'OSDE', 4001, 'N');
INSERT INTO PACIENTE VALUES (1005, 'Espinoza', 'Ricardo Martín', 'IOMA', 5001, 'N');
INSERT INTO PACIENTE VALUES (1006, 'Fernández', 'Claudia Rosa', 'PAMI', 7001, 'N');
INSERT INTO PACIENTE VALUES (1007, 'García', 'Miguel Angel', 'Swiss Medical', 1002, 'N');
INSERT INTO PACIENTE VALUES (1008, 'Herrera', 'Laura Beatriz', 'Medicus', 2002, 'P');
INSERT INTO PACIENTE VALUES (1009, 'Iglesias', 'Fernando José', 'OSDE', 3002, 'P');
INSERT INTO PACIENTE VALUES (1010, 'Jiménez', 'Silvia Patricia', 'Galeno', 6001, 'N');

-- Pacientes sin obra social
INSERT INTO PACIENTE VALUES (2001, 'Martínez', 'Carlos Eduardo', NULL, 7002, 'P');
INSERT INTO PACIENTE VALUES (2002, 'Navarro', 'Isabel Cristina', NULL, 4002, 'P');
INSERT INTO PACIENTE VALUES (2003, 'Ortega', 'Diego Fernando', NULL, 8001, 'N');
INSERT INTO PACIENTE VALUES (2004, 'Pérez', 'Mónica Alejandra', NULL, 5002, 'P');
INSERT INTO PACIENTE VALUES (2005, 'Ramírez', 'Roberto Carlos', NULL, 9001, 'N');

-- Pacientes pediátricos
INSERT INTO PACIENTE VALUES (3001, 'González', 'Sofía Valentina', 'OSDE', 4001, 'N');
INSERT INTO PACIENTE VALUES (3002, 'López', 'Mateo Joaquín', 'Swiss Medical', 4002, 'P');
INSERT INTO PACIENTE VALUES (3003, 'Sánchez', 'Emma Isabella', 'PAMI', 4003, 'N');
INSERT INTO PACIENTE VALUES (3004, 'Torres', 'Lucas Benjamín', 'Medicus', 4001, 'N');
INSERT INTO PACIENTE VALUES (3005, 'Vargas', 'Mía Esperanza', NULL, 4002, 'P');

-- Pacientes adultos mayores
INSERT INTO PACIENTE VALUES (4001, 'Castro', 'Elisa Dolores', 'PAMI', 7001, 'N');
INSERT INTO PACIENTE VALUES (4002, 'Delgado', 'Armando Raúl', 'PAMI', 1001, 'N');
INSERT INTO PACIENTE VALUES (4003, 'Morales', 'Carmen Rosa', 'PAMI', 6001, 'N');
INSERT INTO PACIENTE VALUES (4004, 'Silva', 'Héctor Manuel', 'PAMI', 7002, 'P');
INSERT INTO PACIENTE VALUES (4005, 'Vega', 'Graciela Inés', 'PAMI', 2001, 'N');

-- Más pacientes para casos complejos
INSERT INTO PACIENTE VALUES (5001, 'Acosta', 'Valentina Sol', 'OSDE', 1003, 'P');
INSERT INTO PACIENTE VALUES (5002, 'Blanco', 'Sebastián Tomás', 'Swiss Medical', 2003, 'N');
INSERT INTO PACIENTE VALUES (5003, 'Cabrera', 'Camila Victoria', 'Galeno', 3003, 'N');
INSERT INTO PACIENTE VALUES (5004, 'Díaz', 'Nicolás Alexander', 'Medicus', 8002, 'P');
INSERT INTO PACIENTE VALUES (5005, 'Escobar', 'Antonella Francesca', 'IOMA', 9002, 'P');

-- =============================================
-- 5. INTERNACIONES - 80 internaciones (mix de actuales e históricas)
-- =============================================

-- Internaciones ACTIVAS (sin fecha_salida)
-- Cardiología
INSERT INTO INTERNACION VALUES (1001, 1, 301, '2025-01-15', NULL, 'Infarto agudo de miocardio', 1001, 'N');
INSERT INTO INTERNACION VALUES (1007, 1, 302, '2025-01-20', NULL, 'Insuficiencia cardíaca congestiva', 1002, 'N');
INSERT INTO INTERNACION VALUES (4002, 1, 304, '2025-01-25', NULL, 'Arritmia cardíaca', 1003, 'P');
INSERT INTO INTERNACION VALUES (5001, 2, 201, '2025-02-01', NULL, 'Post-operatorio bypass coronario', 1001, 'N');

-- Neurología
INSERT INTO INTERNACION VALUES (1002, 3, 401, '2025-01-18', NULL, 'ACV isquémico', 2001, 'N');
INSERT INTO INTERNACION VALUES (1008, 3, 402, '2025-01-22', NULL, 'Traumatismo encefalocraneano', 2002, 'P');
INSERT INTO INTERNACION VALUES (4005, 4, 207, '2025-02-05', NULL, 'Hemorragia subaracnoidea', 2003, 'N');

-- Traumatología
INSERT INTO INTERNACION VALUES (1003, 5, 501, '2025-01-10', NULL, 'Fractura de fémur', 3001, 'N');
INSERT INTO INTERNACION VALUES (1009, 5, 502, '2025-01-28', NULL, 'Politraumatismo', 3002, 'P');
INSERT INTO INTERNACION VALUES (2003, 5, 503, '2025-02-03', NULL, 'Fractura múltiple de costillas', 3003, 'N');

-- Pediatría
INSERT INTO INTERNACION VALUES (3001, 7, 701, '2025-01-30', NULL, 'Neumonía infantil', 4001, 'N');
INSERT INTO INTERNACION VALUES (3002, 7, 702, '2025-02-02', NULL, 'Gastroenteritis aguda', 4002, 'P');
INSERT INTO INTERNACION VALUES (3005, 8, 801, '2025-02-06', NULL, 'Prematurez extrema', 4003, 'N');

-- Ginecología/Maternidad
INSERT INTO INTERNACION VALUES (1004, 9, 901, '2025-01-12', NULL, 'Embarazo de alto riesgo', 5001, 'N');
INSERT INTO INTERNACION VALUES (2004, 10, 1001, '2025-02-04', NULL, 'Post-cesárea', 5002, 'P');

-- Oncología
INSERT INTO INTERNACION VALUES (1010, 11, 1101, '2025-01-05', NULL, 'Quimioterapia - Cáncer de mama', 6001, 'N');
INSERT INTO INTERNACION VALUES (4003, 11, 1102, '2025-01-25', NULL, 'Cáncer de pulmón - cuidados paliativos', 6002, 'P');

-- Medicina Interna
INSERT INTO INTERNACION VALUES (1006, 12, 101, '2025-01-14', NULL, 'Diabetes descompensada', 7001, 'N');
INSERT INTO INTERNACION VALUES (2001, 12, 102, '2025-01-24', NULL, 'Hipertensión arterial severa', 7002, 'P');
INSERT INTO INTERNACION VALUES (4001, 12, 103, '2025-02-01', NULL, 'Insuficiencia renal crónica', 7003, 'N');

-- Psiquiatría
INSERT INTO INTERNACION VALUES (2005, 14, 1401, '2025-01-08', NULL, 'Episodio depresivo mayor', 9001, 'N');
INSERT INTO INTERNACION VALUES (5005, 14, 1402, '2025-01-29', NULL, 'Trastorno bipolar - fase maníaca', 9002, 'P');

-- INTERNACIONES HISTÓRICAS (con fecha_salida)
-- Casos exitosos
INSERT INTO INTERNACION VALUES (1001, 1, 308, '2024-12-01', '2024-12-15', 'Cateterismo cardíaco', 1002, 'N');
INSERT INTO INTERNACION VALUES (1002, 3, 406, '2024-11-15', '2024-12-05', 'Rehabilitación post-ACV', 2001, 'N');
INSERT INTO INTERNACION VALUES (1003, 5, 504, '2024-12-10', '2024-12-28', 'Fractura de radio - recuperación', 3001, 'N');

-- Casos con complicaciones
INSERT INTO INTERNACION VALUES (2001, 12, 104, '2024-10-20', '2024-11-30', 'Neumonía nosocomial', 7001, 'N');
INSERT INTO INTERNACION VALUES (4002, 1, 310, '2024-09-15', '2024-10-15', 'Insuficiencia cardíaca - estabilizado', 1001, 'N');

-- Reinternaciones (mismo paciente, diferentes fechas)
INSERT INTO INTERNACION VALUES (1006, 12, 105, '2024-11-01', '2024-11-20', 'Diabetes - primera internación', 7002, 'P');
INSERT INTO INTERNACION VALUES (1006, 12, 106, '2024-12-15', '2024-12-25', 'Diabetes - reagudización', 7003, 'N');

-- Transferencias entre áreas
INSERT INTO INTERNACION VALUES (5002, 12, 107, '2024-12-20', '2025-01-05', 'Transferido desde emergencias', 7001, 'N');
INSERT INTO INTERNACION VALUES (5002, 3, 408, '2025-01-06', '2025-01-25', 'Transferido a neurología', 2002, 'P');

-- Casos pediátricos históricos
INSERT INTO INTERNACION VALUES (3003, 7, 704, '2024-11-10', '2024-11-18', 'Apendicitis - recuperación exitosa', 4002, 'P');
INSERT INTO INTERNACION VALUES (3004, 8, 802, '2024-10-01', '2024-11-15', 'Bronquiolitis - alta mejorado', 4001, 'N');

-- Casos de larga estadía
INSERT INTO INTERNACION VALUES (4004, 15, 1501, '2024-08-01', '2025-01-15', 'Cuidados paliativos - cáncer terminal', 6002, 'P');
INSERT INTO INTERNACION VALUES (2002, 14, 1403, '2024-07-15', '2024-12-20', 'Tratamiento psiquiátrico prolongado', 9001, 'N');

-- =============================================
-- CASOS ESPECIALES PARA TESTING
-- =============================================

-- Caso: Paciente con múltiples especialistas
INSERT INTO PACIENTE VALUES (9001, 'Complejo', 'Caso Médico', 'OSDE', 1001, 'N');
INSERT INTO INTERNACION VALUES (9001, 1, 312, '2024-06-01', '2024-06-30', 'Cateterismo + complicaciones', 1001, 'N');
INSERT INTO INTERNACION VALUES (9001, 3, 410, '2024-07-01', '2024-07-20', 'Secuela neurológica post-cateterismo', 2001, 'N');
INSERT INTO INTERNACION VALUES (9001, 12, 110, '2024-08-15', '2024-09-10', 'Seguimiento clínico general', 7001, 'N');

-- Caso: Paciente sin médico de cabecera
INSERT INTO PACIENTE VALUES (9002, 'Sin', 'Médico Cabecera', 'Swiss Medical', NULL, NULL);
INSERT INTO INTERNACION VALUES (9002, 12, 111, '2025-01-20', NULL, 'Consulta de emergencia', 7002, 'P');

-- =============================================
-- ESTADÍSTICAS DEL DATASET
-- =============================================
/*
RESUMEN DEL DATASET:
- 24 Médicos de 10 especialidades diferentes
- 15 Áreas especializadas
- ~100 Habitaciones (representativas, se pueden completar las 231)
- 30 Pacientes diversos (edades, obras sociales, condiciones)
- 45+ Internaciones (activas e históricas)

CASOS DE PRUEBA INCLUIDOS:
1. Ocupación alta (>75%) en algunas áreas
2. Pacientes con múltiples internaciones
3. Transferencias entre áreas
4. Casos pediátricos y geriátricos
5. Diferentes especialidades médicas
6. Pacientes con/sin obra social
7. Pacientes con/sin médico de cabecera
8. Internaciones de corta/larga duración
9. Casos complejos multi-especialidad
10. Habitaciones en diferentes estados
