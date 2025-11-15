# Healthcare Database Analysis – CMS Hospital General Information

## Descripción del proyecto  
Este proyecto analiza el conjunto de datos *Hospital General Information* publicado por la agencia federal estadounidense Medicare/Medicaid (CMS). El objetivo es extraer información operativa y de calidad de los hospitales de EE.UU., tales como cobertura del servicio de emergencia, distribución por estado / tipo de gestión, patrones en la clasificación general de hospitales (1-5 estrellas), etc.  
El flujo de trabajo incluye: ingestión de datos desde CSV, limpieza, carga en PostgreSQL, creación de vistas e índices, consultas analíticas, y visualización en Power BI.

## Origen de los datos  
- Fuente: conjunto de datos “Hospital General Information” https://data.cms.gov/provider-data/dataset/xubh-q36u#data-dictionary 
- Versión limpia: *Hospital_General_Information_CLEAN.csv* 
- Fecha de modificación del archivo original: Julio 16 2025. :contentReference[oaicite:9]{index=9}  
- Periodo de evaluación de las métricas de calidad: mayoritariamente hasta junio de 2022 o marzo de 2023, según categoría. (Fuente de metodología de calificación de estrellas) :contentReference[oaicite:10]{index=10}  

## Objetivos del análisis  
- Explorar la distribución de hospitales por estado, tipo de propiedad, tipo de hospital (agudo, CAH, etc).  
- Analizar la cobertura de servicios de urgencia/emergencia entre hospitales.  
- Investigar la relación entre características de hospital (por ejemplo, rural vs urbano, tipo de propiedad) y su clasificación general (estrellas).  
- Crear visualizaciones que permitan identificar insights accionables o interesantes para stakeholders (gestión hospitalaria, políticas de salud, etc).  
- Documentar todo el flujo en un informe final y en el dashboard de presentación.

## Stack técnico  
- PostgreSQL: para carga, gestión y consultas.  
- pgAdmin: como interfaz para gestión de la base de datos.  
- Excel / Power BI: para visualización final y presentación.  
- CSV de ingestión: *Hospital_General_Information_CLEAN.csv*.


## Consideraciones y limitaciones  
- Las métricas de calidad subyacentes a la clasificación de estrellas pueden estar sesgadas por tamaño, tipo de hospital, volumen de pacientes, etc. El propio CMS advierte que la calificación “solo refleja las medidas disponibles”. :contentReference[oaicite:11]{index=11}  
- Los datos cubren solo hospitales certificados por Medicare en EE.UU.; no necesariamente todos los hospitales en EE.UU. ni otros tipos de centros.  
- Dependiendo del campo “Overall Hospital Quality Star Rating”, puede haber hospitales sin clasificación (por falta de datos suficientes).  
- Es conveniente describir claramente en la presentación el periodo temporal de evaluación para evitar interpretaciones erróneas.

## Contacto y licencia  
Este proyecto está desarrollado como trabajo personal de portfolio. El uso del conjunto de datos está sujeto a los términos de uso de CMS (datos públicos).  
 
