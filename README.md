# Backend User API - Coink
Implementé una API en .NET con arquitectura por capas.
La validación de integridad está centralizada en la base de datos mediante stored procedures para garantizar consistencia.
El backend solo orquesta la operación y maneja los errores.
El proyecto corre con Docker para facilitar la evaluación.

## Descripción
API de servicios que permite registrar usuarios con la siguiente información:
- Nombre
- Teléfono
- País
- Departamento
- Municipio
- Dirección

La API valida que los datos ingresados sean válidos y que existan las relaciones correctas entre País → Departamento → Municipio.

## Características
- Validación completa de datos de entrada
- Validación de relaciones geográficas (País → Departamento → Municipio)
- Implementación mediante Stored Procedures
- Patrones de diseño: Repository, Service Layer, DTO
- Documentación con Swagger
- Se uso Docker para evitar problemas de versiones
- Manejo de errores

## Tecnologías
- **.NET 8** - Framework de desarrollo
- **ASP.NET Core** - Framework web
- **PostgreSQL 15** - Base de datos
- **Dapper** - ORM ligero
- **Docker & Docker Compose** - Contenedorización
- **Swagger** - Documentación de API

## Requisitos
- Docker y Docker Compose
- O alternativamente:
  - .NET 8 SDK
  - PostgreSQL 15

## Instalación y Ejecución
### Opción 1: Usando Docker
1. Clonar el repositorio:
```bash
git clone <repository-url>
cd backend-user-api-coink
```

2. Ejecutar con Docker Compose:
```bash
docker compose up --build
```

3. La API estará disponible en:
   - **API**: http://localhost:5000
   - **Swagger UI**: http://localhost:5000/swagger

### Opción 2: Ejecución Local
1. Crear la base de datos PostgreSQL:
```bash
# Crear base de datos 'usersdb'
createdb usersdb
```

2. Ejecutar los scripts SQL en orden:
```bash
psql -U postgres -d usersdb -f Database/create_tables.sql
psql -U postgres -d usersdb -f Database/stored_procedures.sql
psql -U postgres -d usersdb -f Database/insert_initial_data.sql
```

3. Configurar la cadena de conexión en `Api/UserApi/appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=usersdb;Username=postgres;Password=tu_password"
  }
}
```

4. Ejecutar la API:
```bash
cd Api/UserApi
dotnet run
```

## Endpoints
### POST /api/usuarios
Registra un nuevo usuario.

**Request Body:**
```json
{
  "nombre": "COINK",
  "telefono": "3121111111",
  "direccion": "Calle 123 #45-67",
  "paisId": 1,
  "departamentoId": 1,
  "municipioId": 1
}
```

**Response Success (201 Created):**
```json
Status: 201 Created
```

**Response Error (400 Bad Request):**
```json
{
  "error": "Ubicación inválida: país, departamento y municipio no coinciden"
}
```

## Validaciones
La API valida:

1. **Datos requeridos**: Todos los campos son obligatorios
2. **Longitud de campos**: 
   - Nombre: máximo 100 caracteres
   - Teléfono: máximo 20 caracteres
   - Dirección: máximo 200 caracteres
4. **Existencia de entidades**: Verifica que País, Departamento y Municipio existan
5. **Relaciones geográficas**: Valida que:
   - El Departamento pertenezca al País especificado
   - El Municipio pertenezca al Departamento especificado

## Estructura de Base de Datos
### Tablas
- **pais**: Países disponibles
- **departamento**: Departamentos con referencia a país
- **municipio**: Municipios con referencia a departamento
- **usuario**: Usuarios registrados con información de general

### Stored Procedures y Funciones
- `sp_insert_usuario` (PROCEDURE): Inserta un nuevo usuario con validación de relaciones geográficas. Valida que el país, departamento y municipio formen una jerarquía válida antes de insertar.
- `sp_get_paises` (FUNCTION): Retorna la lista de todos los países ordenados por nombre.
- `sp_get_departamentos_by_pais` (FUNCTION): Retorna los departamentos de un país específico, ordenados por nombre.
- `sp_get_municipios_by_departamento` (FUNCTION): Retorna los municipios de un departamento específico, ordenados por nombre.

## Estructura del Proyecto
```
backend-user-api-coink/
├── Api/
│   └── UserApi/
│       ├── Controllers/        # Controladores de la API
│       ├── Services/           # Lógica de negocio
│       ├── Repositories/       # Acceso a datos
│       ├── DTOs/              # Data Transfer Objects
│       └── Program.cs         # Configuración de la aplicación
├── Database/
│   ├── create_tables.sql      # Script de creación de tablas
│   ├── stored_procedures.sql  # Stored procedures
│   └── insert_initial_data.sql # Datos iniciales
├── docker-compose.yml         # Configuración de Docker Compose
├── Dockerfile                 # Imagen Docker de la API
└── README.md                  # Este archivo
```

## Patrones de Diseño Implementados
1. **Repository Pattern**: Abstracción del acceso a datos
2. **Service Layer Pattern**: Separación de lógica de negocio
3. **DTO Pattern**: Transferencia de datos entre capas
4. **Dependency Injection**: Inyección de dependencias
5. **Separation of Concerns**: Separación de responsabilidades

## Ejemplos de Uso
### Ejemplo 1: Registrar usuario en Bogotá
```bash
curl -X POST http://localhost:5000/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "María García",
    "telefono": "3121111111",
    "direccion": "Calle 100 #50-30",
    "paisId": 1,
    "departamentoId": 1,
    "municipioId": 1
  }'
```

### Ejemplo 2: Registrar usuario en Medellín
```bash
curl -X POST http://localhost:5000/api/usuarios \
  -H "Content-Type: application/json" \
  -d '{
    "nombre": "Carlos Rodríguez",
    "telefono": "3142222222",
    "direccion": "Carrera 70 #45-20",
    "paisId": 1,
    "departamentoId": 2,
    "municipioId": 5
  }'
```

## Datos Iniciales
La base de datos se inicializa con:

- **1 País**: Colombia
- **5 Departamentos**: Cundinamarca, Antioquia, Valle del Cauca, Atlántico, Santander
- **17 Municipios**: Distribuidos entre los departamentos

### Relaciones Válidas
- **Departamento 1 (Cundinamarca)**: Municipios 1, 2, 3, 4
- **Departamento 2 (Antioquia)**: Municipios 5, 6, 7, 8
- **Departamento 3 (Valle del Cauca)**: Municipios 9, 10, 11
- **Departamento 4 (Atlántico)**: Municipios 12, 13, 14
- **Departamento 5 (Santander)**: Municipios 15, 16, 17

## Manejo de Errores
La API maneja los siguientes tipos de errores:

- **400 Bad Request**: Datos inválidos o relaciones geográficas incorrectas
- **500 Internal Server Error**: Errores internos del servidor

Los errores se retornan en formato JSON:
```json
{
  "error": "Mensaje de error descriptivo"
}
```

## Documentación API
Una vez ejecutada la aplicación, la documentación interactiva de Swagger está disponible en:

http://localhost:5000/swagger

## Autor
**Kevin Daniel Castro Mendoza** - FullStack Developer

- **LinkedIn**: [daniel-castro-91235a348](https://www.linkedin.com/in/daniel-castro-91235a348/)
- **GitHub**: [f1f2f3f4f5f6f7](https://github.com/f1f2f3f4f5f6f7)

---

Desarrollado para **Coink**

