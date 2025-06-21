# 🧹 Cleaning Messy Datasets: Public Survey Data

This project focuses on cleaning and preparing a real-world survey dataset — the **Adult Income Dataset** — often used for income classification tasks. The dataset contains information such as age, education level, occupation, and marital status, and is frequently used in predictive modeling to determine whether a person earns more than $50K per year.

---

## 📦 Dataset

**Source:** UCI Machine Learning Repository  
**Link:** [Adult Data Set](https://archive.ics.uci.edu/ml/datasets/adult)  
**Format:** CSV, ~32,000 rows, 15 features  
**Target variable:** `income` (>50K or <=50K)

---

## 🧽 Project Goals

1. **Identify and handle missing values and duplicates**
2. **Detect and treat outliers and formatting issues**
3. **Correct data type mismatches and inconsistent encodings**
4. **Standardize categorical variables and remove noise**
5. **Document every step of the cleaning pipeline**
6. **Export a clean, ready-to-model dataset**

---

## 🔧 Tools Used

- Python  
- Pandas  
- NumPy  
- Jupyter Notebook  

---

## 📊 Key Cleaning Steps

- Replaced missing values represented as `"?"` in object columns
- Removed rows with ambiguous or corrupted entries
- Stripped whitespace and unified category labels
- Converted columns to appropriate data types
- Handled duplicates and imbalanced values
- Identified potential outliers (e.g., extreme ages or working hours)
- Exported cleaned dataset to CSV

---

## ✅ Outcome

The cleaned dataset is ready for further **EDA** and **machine learning modeling**, with clearly defined features, consistent formats, and no missing values. This cleaning process improves data quality and ensures reliability in downstream tasks.

---

## 📘 Notes

- This project does not include modeling — the focus is entirely on **data quality**.
- The pipeline is reproducible and documented for clarity.

---

## 📌 Next Steps

- Perform EDA and visualize relationships between features  
- Build classification models using the cleaned dataset  
- Deploy findings in an interactive dashboard (optional)

---

