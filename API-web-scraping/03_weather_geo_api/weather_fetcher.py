import requests
import pandas as pd
from datetime import datetime

# Coordenadas de Buenos Aires
latitude = -34.61
longitude = -58.38

# API endpoint
url = "https://api.open-meteo.com/v1/forecast"
params = {
    "latitude": latitude,
    "longitude": longitude,
    "current_weather": True
}

response = requests.get(url, params=params)
data = response.json()

# Extraer datos del clima actual
weather = data["current_weather"]
weather_data = {
    "city": "Buenos Aires",
    "temperature_C": weather["temperature"],
    "windspeed_kmh": weather["windspeed"],
    "weather_code": weather["weathercode"],
    "time": weather["time"],
    "scraped_at": datetime.now().isoformat()
}

# Guardar en CSV
df = pd.DataFrame([weather_data])
df.to_csv("weather_data.csv", index=False)
print("✔ Datos climáticos guardados en weather_data.csv")
