CREATE TABLE pais (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE departamento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais_id INT NOT NULL,
    CONSTRAINT fk_departamento_pais
        FOREIGN KEY (pais_id) REFERENCES pais(id)
);

CREATE TABLE municipio (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento_id INT NOT NULL,
    CONSTRAINT fk_municipio_departamento
        FOREIGN KEY (departamento_id) REFERENCES departamento(id)
);

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    pais_id INT NOT NULL,
    departamento_id INT NOT NULL,
    municipio_id INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_pais
        FOREIGN KEY (pais_id) REFERENCES pais(id),
    CONSTRAINT fk_usuario_departamento
        FOREIGN KEY (departamento_id) REFERENCES departamento(id),
    CONSTRAINT fk_usuario_municipio
        FOREIGN KEY (municipio_id) REFERENCES municipio(id)
);
