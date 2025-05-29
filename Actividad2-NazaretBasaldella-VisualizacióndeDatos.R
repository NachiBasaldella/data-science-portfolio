# Cargamos las librerías necesarias
library(tidyverse)

# Cargamos el dataset iris
data(iris)

# Creamos una lista con los nombres de las variables numéricas
variables <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
#Punto 1 
# Para cada variable, generamos una gráfica de densidad
for (var in variables) {
  ggplot(iris, aes_string(x = var)) +
    geom_density(fill = "skyblue", alpha = 0.5) +
    labs(title = paste("Distribución de", var), x = var, y = "Densidad") +
    theme_minimal() -> p
  print(p)
}
#Punto 2
# 1. Distribuciones por especie usando geom_density()
for (var in variables) {
  ggplot(iris, aes_string(x = var, fill = "Species")) +
    geom_density(alpha = 0.5) +
    labs(title = paste("Distribución de", var, "por especie"),
         x = var, y = "Densidad") +
    theme_minimal() +
    scale_fill_brewer(palette = "Set1") -> p
  print(p)
}

# 2. Distribuciones por especie usando geom_boxplot()
for (var in variables) {
  ggplot(iris, aes_string(x = "Species", y = var, fill = "Species")) +
    geom_boxplot(alpha = 0.7) +
    labs(title = paste("Boxplot de", var, "por especie"),
         x = "Especie", y = var) +
    theme_minimal() +
    scale_fill_brewer(palette = "Set1") -> p
  print(p)
}

#Punto3
# Calculamos media, mediana y desviación estándar de cada variable
iris %>%
  summarise(
    Sepal.Length_media = mean(Sepal.Length),
    Sepal.Length_mediana = median(Sepal.Length),
    Sepal.Length_sd = sd(Sepal.Length),
    Sepal.Width_media = mean(Sepal.Width),
    Sepal.Width_mediana = median(Sepal.Width),
    Sepal.Width_sd = sd(Sepal.Width),
    Petal.Length_media = mean(Petal.Length),
    Petal.Length_mediana = median(Petal.Length),
    Petal.Length_sd = sd(Petal.Length),
    Petal.Width_media = mean(Petal.Width),
    Petal.Width_mediana = median(Petal.Width),
    Petal.Width_sd = sd(Petal.Width)
  )

#Punto 4
iris %>%
  group_by(Species) %>%
  summarise(count = n())

#Punto5
# Calculamos media, mediana y desviación típica por especie
iris %>%
  group_by(Species) %>%
  summarise(
    Sepal.Length_media = mean(Sepal.Length),
    Sepal.Length_mediana = median(Sepal.Length),
    Sepal.Length_sd = sd(Sepal.Length),
    Sepal.Width_media = mean(Sepal.Width),
    Sepal.Width_mediana = median(Sepal.Width),
    Sepal.Width_sd = sd(Sepal.Width),
    Petal.Length_media = mean(Petal.Length),
    Petal.Length_mediana = median(Petal.Length),
    Petal.Length_sd = sd(Petal.Length),
    Petal.Width_media = mean(Petal.Width),
    Petal.Width_mediana = median(Petal.Width),
    Petal.Width_sd = sd(Petal.Width)
  )
#Punto 6
# Gráfico de dispersión Sepal.Length vs Sepal.Width coloreado por Species
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Dispersión de Sepal.Length vs Sepal.Width",
       x = "Longitud del Sépalo",
       y = "Anchura del Sépalo") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

#Punto 7
# Gráfico de dispersión Petal.Length vs Petal.Width coloreado por Species
ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Dispersión de Petal.Length vs Petal.Width",
       x = "Longitud del Pétalo",
       y = "Anchura del Pétalo") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")

#Punto 8
# Crear un subconjunto con las condiciones indicadas
iris_sub <- iris %>%
  filter(Petal.Length > 5.5, Sepal.Length > 4.5)

# Contar el número de observaciones por especie en el subconjunto
iris_sub %>%
  count(Species)

# Crear un diagrama de barras con los recuentos
ggplot(iris_sub, aes(x = Species, fill = Species)) +
  geom_bar() +
  labs(title = "Recuento de especies (Petal.Length > 5.5 y Sepal.Length > 4.5)",
       x = "Especie",
       y = "Número de observaciones") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")

#Punto 9

# Gráfico de dispersión Petal.Length vs Petal.Width para el subconjunto
ggplot(iris_sub, aes(x = Petal.Length, y = Petal.Width, color = Species)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Dispersión de Petal.Length vs Petal.Width (Subconjunto)",
       x = "Longitud del Pétalo",
       y = "Anchura del Pétalo") +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")