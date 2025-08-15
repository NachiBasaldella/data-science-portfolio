import requests
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

# 1. Llamar a la API de CoinGecko para BTC últimos 7 días
url = "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart"
params = {
    "vs_currency": "usd",
    "days": 7
}
response = requests.get(url, params=params)
data = response.json()

# 2. Convertir los precios a DataFrame
prices = data["prices"]  # lista de [timestamp, price]
df = pd.DataFrame(prices, columns=["timestamp", "price"])

# Convertir timestamp a datetime legible
df["timestamp"] = pd.to_datetime(df["timestamp"], unit="ms")
df.set_index("timestamp", inplace=True)

# 3. Guardar en CSV
df.to_csv("crypto_prices.csv")
print("✔ Datos guardados en crypto_prices.csv")

# 4. Graficar
plt.figure(figsize=(10, 5))
plt.plot(df.index, df["price"], label="Bitcoin Price (USD)", color="orange")
plt.title("Bitcoin Price - Last 7 Days")
plt.xlabel("Date")
plt.ylabel("Price (USD)")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.savefig("btc_price_chart.png")
plt.show()
