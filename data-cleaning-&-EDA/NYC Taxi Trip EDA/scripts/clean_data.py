# %%
# notebooks/eda_nyc_taxi.ipynb
! pip install seaborn

# --- 1. Importar librerías ---
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns




# %%
import pandas as pd

# Ruta del archivo Parquet de entrada
input_path = "C:/Users/nazar/OneDrive/Documentos/EDA/yellow_tripdata_2023-01.parquet"

# Ruta del archivo CSV de salida
output_path = "C:/Users/nazar/OneDrive/Documentos/EDA/yellow_tripdata_2023-01.csv"

# Leer el archivo Parquet
df = pd.read_parquet(input_path)

# Guardar como CSV
df.to_csv(output_path, index=False)

print("✅ Conversión completada. Archivo guardado como CSV.")


# %%
import pandas as pd

input_path = "C:/Users/nazar/OneDrive/Documentos/EDA/yellow_tripdata_2023-01.parquet"
df = pd.read_parquet(input_path, engine='pyarrow')

# Seleccionar solo las primeras 50,000 filas por ejemplo
df_sample = df.head(50000)

# Guardar la muestra como CSV
output_path = "C:/Users/nazar/OneDrive/Documentos/EDA/yellow_trip_sample.csv"
df_sample.to_csv(output_path, index=False)

print("✅ Archivo reducido guardado como CSV.")


# %%


# Estilo de gráficos
sns.set(style="whitegrid")
plt.rcParams["figure.figsize"] = (12, 6)

# ---  Cargar el dataset ---
file_path = "C:/Users/nazar/OneDrive/Documentos/EDA/yellow_tripdata_2023-01.csv"
df = pd.read_csv(file_path, low_memory=False)

# ---  Vista general ---
print("Shape (filas, columnas):", df.shape)
display(df.head())

# ---  Información general ---
df.info()

# ---  Ver columnas ---
print("\nColumnas del dataset:")
print(df.columns.tolist())


# %% [markdown]
# Celda 1: Análisis de trip_distance

# %%
# --- Análisis univariado: trip_distance ---
print("Descripción estadística de 'trip_distance':")
print(df['trip_distance'].describe())

# Histograma de distancias
plt.figure()
sns.histplot(df['trip_distance'], bins=50, kde=True)
plt.title("Distribución de distancias de viaje")
plt.xlabel("Distancia (millas)")
plt.ylabel("Frecuencia")
plt.xlim(0, 20)  # Limitar eje X para evitar outliers extremos
plt.show()


# %% [markdown]
# Celda 2: Análisis de fare_amount

# %%
# --- Análisis univariado: fare_amount ---
print("Descripción estadística de 'fare_amount':")
print(df['fare_amount'].describe())

# Histograma de tarifas
plt.figure()
sns.histplot(df['fare_amount'], bins=50, kde=True)
plt.title("Distribución de monto de tarifa")
plt.xlabel("Tarifa ($)")
plt.ylabel("Frecuencia")
plt.xlim(0, 100)
plt.show()


# %% [markdown]
# Celda 3: Análisis de tip_amount

# %%
# --- Análisis univariado: tip_amount ---
print("Descripción estadística de 'tip_amount':")
print(df['tip_amount'].describe())

# Histograma de propinas
plt.figure()
sns.histplot(df['tip_amount'], bins=40, kde=True)
plt.title("Distribución de propinas")
plt.xlabel("Propina ($)")
plt.ylabel("Frecuencia")
plt.xlim(0, 20)
plt.show()


# %% [markdown]
# Celda 4: Análisis de passenger_count

# %%
# --- Análisis univariado: passenger_count ---
print("Frecuencia de pasajeros por viaje:")
print(df['passenger_count'].value_counts())

# Gráfico de barras
plt.figure()
sns.countplot(data=df, x='passenger_count')
plt.title("Cantidad de pasajeros por viaje")
plt.xlabel("Número de pasajeros")
plt.ylabel("Cantidad de viajes")
plt.show()


# %% [markdown]
# *Limpieza del Dataset*

# %%
# Ver cantidad de nulos por columna
print("Valores nulos por columna:")
print(df.isnull().sum())

# Eliminar filas con nulos en columnas clave
df = df.dropna(subset=['trip_distance', 'fare_amount', 'passenger_count'])
print("✅ Filas con nulos eliminadas.")


# %% [markdown]
# *Corregir tipos de datos (fechas)*

# %%
# Convertir columnas de fecha
df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])

print("✅ Columnas de fecha convertidas.")


# %% [markdown]
# *Filtrar valores extremos (outliers)*
# Vamos a eliminar:
# -Distancias negativas o ridículamente altas
# -Tarifas negativas o muy elevadas
# -Propinas negativas
# -Cantidad de pasajeros inválida (0 o más de 7)

# %%
# Condiciones para filtrar datos inválidos
df = df[df['trip_distance'].between(0.1, 50)]
df = df[df['fare_amount'].between(1, 250)]
df = df[df['tip_amount'].between(0, 100)]
df = df[df['passenger_count'].between(1, 7)]

print("✅ Outliers eliminados.")
print("Dataset limpio - nuevo shape:", df.shape)


# %% [markdown]
# *Eliminar columnas innecesarias*

# %%
print(df.columns.tolist())


# %%
cols_to_drop = [
    'VendorID', 'store_and_fwd_flag', 'RatecodeID', 'Extra',
    'mta_tax', 'improvement_surcharge', 'congestion_surcharge',
    'airport_fee'
]

df = df.drop(columns=[col for col in cols_to_drop if col in df.columns])
print("✅ Columnas innecesarias eliminadas.")


# %% [markdown]
# *Guardar el dataset limpio*

# %%
# Guardar dataset limpio en nueva carpeta
df.to_csv("C:/Users/nazar/OneDrive/Documentos/EDA/yellow_trip_cleaned.csv", index=False)
print("✅ Dataset limpio guardado como yellow_trip_cleaned.csv")



