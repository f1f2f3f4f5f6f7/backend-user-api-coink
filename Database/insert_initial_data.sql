-- Datos iniciales para la base de datos
-- Este script se ejecuta después de create_tables.sql

-- Insertar países
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pais WHERE id = 1) THEN
        INSERT INTO pais (id, nombre) VALUES (1, 'Colombia');
    END IF;
END $$;

-- Insertar departamentos
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM departamento WHERE id = 1) THEN
        INSERT INTO departamento (id, nombre, pais_id) VALUES 
            (1, 'Cundinamarca', 1),
            (2, 'Antioquia', 1),
            (3, 'Valle del Cauca', 1),
            (4, 'Atlántico', 1),
            (5, 'Santander', 1);
    END IF;
END $$;

-- Insertar municipios
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM municipio WHERE id = 1) THEN
        INSERT INTO municipio (id, nombre, departamento_id) VALUES 
            -- Cundinamarca
            (1, 'Bogotá', 1),
            (2, 'Chía', 1),
            (3, 'Zipaquirá', 1),
            (4, 'Soacha', 1),
            -- Antioquia
            (5, 'Medellín', 2),
            (6, 'Bello', 2),
            (7, 'Itagüí', 2),
            (8, 'Envigado', 2),
            -- Valle del Cauca
            (9, 'Cali', 3),
            (10, 'Palmira', 3),
            (11, 'Buenaventura', 3),
            -- Atlántico
            (12, 'Barranquilla', 4),
            (13, 'Soledad', 4),
            (14, 'Malambo', 4),
            -- Santander
            (15, 'Bucaramanga', 5),
            (16, 'Floridablanca', 5),
            (17, 'Girón', 5);
    END IF;
END $$;
