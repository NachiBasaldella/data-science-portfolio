# Guía de visualización (Power BI / Excel)

## Conexión a PostgreSQL (recomendada)
1. Instalar Npgsql 4.x (x64) si PBI lo solicita.
2. Power BI Desktop → Get Data → PostgreSQL.
3. Server: `localhost`, Database: `cms_hospitals`.
4. Advanced options → SQL: `SELECT * FROM cms.v_hospitals_clean;`
5. Import (o DirectQuery).

### Tipos de dato
- `overall_rating`: Whole number
- `emergency_services`, `birthing_friendly`: True/False
- Categóricas: Text

### Medidas DAX
- Hospitals Total, With Rating, Avg Rating, ER Count, Pct With Rating, Pct Emergency, Five Star Count, Pct Five Star (ver archivo 10_analysis.sql o README).

### Visuales sugeridos
- Slicers: State, Ownership, Type
- KPI cards: Hospitals Total, Pct Emergency, Pct With Rating, Avg Rating
- Bar chart: Top estados por Avg Rating (filtra `With Rating >= 30`)
- Stacked bar: Cobertura de ER por estado
- Matrix: Avg Rating por Ownership x Type
- Tabla: Five-Star Showcase

## Alternativa: CSV
Exportar desde pgAdmin y cargar CSVs a Power BI/Excel. Mantener separadores UTF-8 con Header. 

