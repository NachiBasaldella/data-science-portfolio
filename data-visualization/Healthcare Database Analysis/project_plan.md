# Plan de Proyecto – Healthcare Database Analysis

## 1. Inicio del proyecto  
**Alcance**: Análisis de hospitales de EE.UU. certificados por Medicare utilizando el dataset Hospital General Information de CMS.

### 1.1 Objetivos específicos  
- Preparar los datos (limpieza, normalización) para análisis.  
- Cargar en PostgreSQL y construir un esquema adecuado.  
- Realizar análisis descriptivo exploratorio (distribución geográfica, tipo de hospital, clasificación de estrellas).  
- Investigar relaciones entre características de hospital y rating global.  
- Crear dashboard para portfolio que comunique los hallazgos de forma visual e interactiva.  
- Generar informe escrito que documente metodología, resultados, conclusiones y limitaciones.

### 1.2 Entregables  
- README.md y project_plan.md (documentación del proyecto).  
- Script SQL de creación de tablas y carga de datos.  
- Vistas SQL para análisis.  
- Exportaciones de tablas derivadas (CSV).  
- Dashboard en Power BI 
- Informe escrito (PDF) con resumen ejecutivo, metodología, resultados, visualizaciones, conclusiones, y recomendaciones.  

## 2. Preparación de datos  
**Tareas**:  
- Revisión del archivo CSV “Hospital_General_Information_CLEAN.csv”.  
- Validación de cabecera (38 campos según especificación).  
- Identificación y tratamiento de valores nulos, códigos de tipo “Not Available”.  
- Normalización de campos categóricos (estado, tipo de gestión, tipo de hospital).  
- Conversión de tipos de datos para PostgreSQL (fechas, números, cadenas).  
- Verificación de integridad (clave primaria, duplicados).  

**Duración estimada**: 1-2 días

## 3. Carga en base de datos y modelado  
**Tareas**:  
- Crear esquema en PostgreSQL: tabla principal  
- Crear índices relevantes (estado, rating, tipo de hospital).  
- Cargar datos CSV en la tabla.  
- Crear vistas de soporte para análisis rápido 
- Verificar volumen de registros, validación de los campos clave.

**Duración estimada**: 1 día

## 4. Análisis exploratorio y consultas SQL  
**Tareas**:  
- Consultas descriptivas: número de hospitales por estado, por tipo, por propiedad.  
- Distribución de la clasificación de estrellas (1-5) global y por estado.  
- Cobertura de servicio de emergencia (“Emergency Services” existe como campo) por tipo de hospital.  
- Investigaciones cruzadas: por ejemplo, “¿los hospitales 5-estrellas tienen menor proporción de hospitales rurales?”; “¿Existe diferencia de rating medio entre hospitales públicos vs privados?”.  
- Exportación de resultados relevantes en CSV para su uso en visualización.

**Duración estimada**: 2-3 días

## 5. Visualización / Dashboard  
**Tareas**:  
- Importar los resultados analíticos a Power BI.  
- Diseñar dashboard con al menos las siguientes visualizaciones:  
  1. Mapa de EE.UU. con número de hospitales y rating medio por estado.  
  2. Gráfico de barras / columnas mostrando número de hospitales por rating (1-5) y por tipo de propiedad.  
  3. Tabla o filtro interactivo para explorar hospitales por estado, tipo y rating.  
  4. Indicador clave: porcentaje de hospitales con emergencias por cada categoría de rating.  
- Asegurar que el dashboard es limpio, legible, y apto para presentar en portfolio.  
- Añadir explicaciones/contexto en el dashboard (etiquetas, títulos, notas).

**Duración estimada**: 1-2 días

## 6. Informe final y preparación del portfolio  
**Tareas**:  
- Redactar informe con los siguientes apartados:  
  - Resumen ejecutivo  
  - Metodología (fuente de datos, periodo, limpieza, base de datos, análisis)  
  - Resultados clave (hallazgos)  
  - Visualizaciones destacadas  
  - Conclusiones y recomendaciones (por ejemplo, implicaciones para gestión hospitalaria, limitaciones de los datos)  
  - Apéndice: pasos de carga, vistas SQL, limpieza de datos.  
- Preparar repositorio / carpeta de portfolio con: datos (o referencia al origen), scripts, informe, dashboard, documentación.  
- Actualizar README.md y asegurarse de que todo está ordenado y listo para presentación.

**Duración estimada**: 1 día

## 7. Revisión y cierre  
**Tareas**:  
- Verificar que todos los archivos funcionan correctamente (SQL carga, dashboard abre, vistas correctas).   
- Ajustes finales: presentación visual, tipografía, explicación de contexto del proyecto.  

**Duración estimada**: 0.5 día

