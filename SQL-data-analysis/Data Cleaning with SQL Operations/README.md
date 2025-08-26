# Data Cleaning with SQL Operations — NYC Film Permits

Este proyecto muestra un flujo de **limpieza de datos con SQL** usando el dataset público **Film Permits** de NYC Open Data.

- **Fuente:** NYC Open Data – Film Permits (`tg4x-b46p`)
- **URL directa:** https://data.cityofnewyork.us/City-Government/Film-Permits/tg4x-b46p
- **Objetivo:** dejar una tabla limpia y analizable, estandarizando formatos, manejando nulos y removiendo duplicados.

## Qué trae el dataset (campos comunes)
> Los nombres pueden cambiar con el tiempo. Este proyecto se enfoca en columnas típicas:
- `event_id`, `event_type`, `event_status`
- `boro`, `zip_code`
- `start_datetime`, `end_datetime`
- `parking_held`, `street_closure` (banderas Y/N)
- `production_company`, `title`, `category`, `subcategory`
- `created_date`, `modified_date`
- `location`, `film_project_type` u otras variantes relacionadas a ubicación y tipo

## Problemas típicos a limpiar
- Mayúsculas/minúsculas y espacios extras en texto (ej. `boro`, `category`).
- ZIP codes con menos de 5 dígitos o caracteres no numéricos.
- Fechas como strings en distintos formatos y zonas horarias.
- Banderas Y/N en texto que conviene convertir a boolean.
- Duplicados por re-emisiones del mismo permiso o modificaciones.
- Campos vacíos/nulos en variables clave.

## Requisitos
- PostgreSQL 13+ (puede adaptarse a SQLite/MySQL).
- CSV exportado desde la página de NYC Open Data.

## Pasos
1. **Descarga**  
   En la página del dataset, usa **Export → CSV** y guarda el archivo como `film_permits.csv` en `data/`.

2. **Crear tabla cruda y cargar**  
   Ejecuta `sql/01_create_raw_and_load.sql` (contiene `CREATE TABLE` y `\copy` o `COPY`).

3. **Limpieza y normalización**  
   Ejecuta `sql/02_clean_transform.sql` para:
   - Trim/upper/lower según convenga en campos de texto.
   - Parsear fechas a `TIMESTAMP`.
   - Normalizar ZIP a 5 dígitos.
   - Convertir Y/N → boolean.
   - Remover duplicados mediante `ROW_NUMBER()`.

4. **Verificación básica**  
   Ejecuta `sql/03_qc_checks.sql` para chequear:
   - % de nulos por columna clave.
   - Rango de fechas válido.
   - ZIPs no válidos.
   - Conteo de duplicados.

## Salidas
- `film_permits_raw` — datos tal cual del CSV.
- `film_permits_clean` — datos limpios listos para análisis.

## Ideas de análisis posteriores
- Volumen de permisos por borough/mes.
- Duración de rodajes (`end - start`).
- Hotspots por ZIP/ubicación.
- Series temporales antes/después de fechas específicas.

## Licencia
Respeta la licencia indicada por NYC Open Data para uso y atribución.

