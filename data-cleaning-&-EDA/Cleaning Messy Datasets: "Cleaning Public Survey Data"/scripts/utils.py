import os
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd


def save_boxplots(df, columns, output_dir="outputs"):
    """
    Guarda un boxplot para cada columna numérica.
    """
    os.makedirs(output_dir, exist_ok=True)
    for col in columns:
        plt.figure(figsize=(6, 1.5))
        sns.boxplot(x=df[col])
        plt.title(f'Boxplot — {col}')
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, f'boxplot_{col}.png'))
        plt.close()


def save_summary(df, columns, output_dir="outputs"):
    """
    Guarda estadísticas descriptivas en CSV.
    """
    os.makedirs(output_dir, exist_ok=True)
    numeric_summary = df[columns].describe()
    numeric_summary.to_csv(os.path.join(output_dir, "summary_statistics.csv"))


def save_dataset(df, filename="adult_clean.csv", output_dir="outputs"):
    """
    Guarda el DataFrame limpio como CSV.
    """
    os.makedirs(output_dir, exist_ok=True)
    df.to_csv(os.path.join(output_dir, filename), index=False)


def save_excel_summary(df, numeric_cols=None, output_dir="outputs"):
    """
    Guarda resúmenes numéricos y categóricos en un Excel.
    """
    os.makedirs(output_dir, exist_ok=True)
    file_path = os.path.join(output_dir, "summary_tables.xlsx")
    with pd.ExcelWriter(file_path) as writer:
        if numeric_cols:
            df[numeric_cols].describe().to_excel(writer, sheet_name="Numeric Summary")
        df.describe(include='object').to_excel(writer, sheet_name="Categorical Summary")
