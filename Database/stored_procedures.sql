CREATE OR REPLACE PROCEDURE sp_insert_usuario(
    p_nombre VARCHAR,
    p_telefono VARCHAR,
    p_direccion VARCHAR,
    p_pais_id INT,
    p_departamento_id INT,
    p_municipio_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar jerarquía completa
    IF NOT EXISTS (
        SELECT 1
        FROM municipio m
        JOIN departamento d ON m.departamento_id = d.id
        WHERE m.id = p_municipio_id
          AND d.id = p_departamento_id
          AND d.pais_id = p_pais_id
    ) THEN
        RAISE EXCEPTION 'Ubicación inválida: país, departamento y municipio no coinciden';
    END IF;

    INSERT INTO usuario (nombre, telefono, direccion, pais_id, departamento_id, municipio_id)
    VALUES (p_nombre, p_telefono, p_direccion, p_pais_id, p_departamento_id, p_municipio_id);
END;
$$;
CREATE OR REPLACE FUNCTION sp_get_paises()
RETURNS TABLE(id INT, nombre VARCHAR)
LANGUAGE sql
AS $$
    SELECT id, nombre FROM pais ORDER BY nombre;
$$;

CREATE OR REPLACE FUNCTION sp_get_departamentos_by_pais(p_pais_id INT)
RETURNS TABLE(id INT, nombre VARCHAR)
LANGUAGE sql
AS $$
    SELECT id, nombre
    FROM departamento
    WHERE pais_id = p_pais_id
    ORDER BY nombre;
$$;

CREATE OR REPLACE FUNCTION sp_get_municipios_by_departamento(p_departamento_id INT)
RETURNS TABLE(id INT, nombre VARCHAR)
LANGUAGE sql
AS $$
    SELECT id, nombre
    FROM municipio
    WHERE departamento_id = p_departamento_id
    ORDER BY nombre;
$$;
