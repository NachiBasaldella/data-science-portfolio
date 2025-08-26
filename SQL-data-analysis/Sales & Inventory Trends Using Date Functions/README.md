Sales & Inventory Trends Using Date Functions (E‑Commerce Data)

Proyecto basado en Online Retail (UK e‑commerce 2010–2011). Motor objetivo: PostgreSQL.
https://www.kaggle.com/datasets/carrie1/ecommerce-data

Estructura del repo
<img width="741" height="304" alt="image" src="https://github.com/user-attachments/assets/de947e63-4afe-4a5d-9360-caacd5b76c17" />

1. Objetivo

Construir un mini‑mart en PostgreSQL con ventas de e‑commerce y simular inventario para analizar:

Tendencias mensuales de revenue y unidades

Crecimiento MoM/YoY por producto

Días con stockout y Days of Inventory on Hand (DoH)

2. Requisitos

PostgreSQL 13+ (ideal 15/16)

Acceso a la CLI (psql) o a un cliente SQL

Archivo data/raw/OnlineRetail.csv (Kaggle “E-Commerce Data”)

3. Instalación rápida
# 1) Crear DB (opcional)
createdb ecommerce


# 2) Ejecutar scripts en orden
psql -d ecommerce -f sql/00_staging.sql
psql -d ecommerce -v CSV_PATH='data/raw/OnlineRetail.csv' -f sql/10_model.sql
psql -d ecommerce -f sql/20_calendar.sql
psql -d ecommerce -f sql/30_inventory.sql
psql -d ecommerce -f sql/40_queries.sql

Nota: 10_model.sql acepta la variable CSV_PATH para el COPY si decides moverlo allí; en este repo el COPY está en 00_staging.sql. Puedes usar \set CSV_PATH 'data/raw/OnlineRetail.csv' dentro de psql.

4. Outputs esperados

Tabla mart.inventory_snapshots con on‑hand diario por producto.

Vistas/consultas con revenue mensual, MoM por producto, stockouts y DoH.

Gráficos opcionales (no incluidos en SQL) a partir de CSV exportados.

5. Validaciones rápidas

qty >= -1000 y unit_price >= 0 (devoluciones permiten negativos en qty).

orders.is_return verdadero si InvoiceNo inicia con C.

Fechas dentro de 2010–2011.

6. Próximos pasos

Mapear categorías por StockCode para análisis por categoría.

Añadir tabla suppliers y lead times sintéticos.

Exportar resultados a /visuals con tu herramienta favorita.

## Uso rápido
1. Coloca `data/raw/OnlineRetail.csv`.
2. Ejecuta en orden: `sql/00_staging.sql` → `10_model.sql` → `20_calendar.sql` → `30_inventory.sql` → `40_queries.sql`.
3. Exporta resultados para visualización (opcional).


## Estructura
- `staging.ecommerce_raw` ← CSV
- `mart.products`, `mart.customers`, `mart.orders`, `mart.order_items`
- `mart.calendar`, `mart.inventory_snapshots`


## Notas
- Facturas con prefijo `C` = devoluciones. Se marcan en `orders.is_return`.
- `Quantity` puede ser negativa (se respeta para KPIs de devoluciones).

