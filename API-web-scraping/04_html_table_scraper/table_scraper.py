import pandas as pd

# URL de la tabla de Wikipedia
url = "https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)"

# Leer todas las tablas de la página
tables = pd.read_html(url)

# Mostrar cuántas tablas encontró
print(f"✔ {len(tables)} tablas encontradas.")

# Elegir una tabla (por inspección sabemos que la primera es la útil)
df = tables[2]  # Puedes cambiar el índice si ves otra tabla útil

# Mostrar las primeras filas
print(df.head())

# Guardar en CSV
df.to_csv("gdp_table.csv", index=False)
print("✅ Tabla guardada en gdp_table.csv")
