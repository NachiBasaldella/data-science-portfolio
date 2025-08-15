import streamlit as st
import pandas as pd
import plotly.express as px

# Título
st.title("📊 NYC Taxi Trip Dashboard")

# Cargar los datos
@st.cache_data
def load_data():
   return pd.read_csv("yellow_trip_cleaned.csv")


df = load_data()

# Sidebar con filtros
st.sidebar.header("Filtros")
hour_selected = st.sidebar.slider("Selecciona una hora del día", 0, 23, 12)

# Mostrar KPIs
st.subheader("🔢 Métricas Principales")
col1, col2, col3 = st.columns(3)
col1.metric("Total de Viajes", f"{df.shape[0]:,}")
col2.metric("Distancia Promedio", f"{df['trip_distance'].mean():.2f} mi")
col3.metric("Propina Promedio", f"${df['tip_amount'].mean():.2f}")

# Gráfico 1: Tarifas vs Distancia
st.subheader("🚕 Relación entre Tarifa y Distancia")
fig1 = px.scatter(
    df,
    x="trip_distance",
    y="fare_amount",
    title="Tarifa vs Distancia",
    opacity=0.5
)
st.plotly_chart(fig1, use_container_width=True)

# Gráfico 2: Viajes por hora
st.subheader("🕒 Viajes por Hora del Día")
df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
df['pickup_hour'] = df['tpep_pickup_datetime'].dt.hour
hour_counts = df['pickup_hour'].value_counts().sort_index()

fig2 = px.bar(
    x=hour_counts.index,
    y=hour_counts.values,
    labels={"x": "Hora", "y": "Cantidad de Viajes"},
    title="Cantidad de Viajes por Hora"
)
st.plotly_chart(fig2, use_container_width=True)

# Filtro por hora seleccionada
st.subheader(f"📍 Datos para la hora seleccionada: {hour_selected}:00")
df_filtered = df[df['pickup_hour'] == hour_selected]
st.write(df_filtered[['tpep_pickup_datetime', 'trip_distance', 'fare_amount', 'tip_amount']].head(10))
