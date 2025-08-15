import requests
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime

# URL del sitio
URL = "https://www.infobae.com/"

# Realizar la solicitud HTTP
response = requests.get(URL)
soup = BeautifulSoup(response.text, "html.parser")

# Buscar titulares (ajustado según estructura real del sitio)
headlines = soup.find_all("h2")

# Procesar resultados
news = []
for h in headlines:
    title = h.get_text(strip=True)
    parent = h.find_parent("a")
    link = parent["href"] if parent and parent.has_attr("href") else URL
    news.append({
        "title": title,
        "link": link,
        "scraped_at": datetime.now().isoformat()
    })

# Guardar en CSV
df = pd.DataFrame(news)
df.to_csv("infobae_headlines.csv", index=False, encoding='utf-8-sig')

print(f"✔ {len(df)} titulares guardados en infobae_headlines.csv")


