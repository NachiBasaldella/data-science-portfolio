# Evaluation Report — Diabetes Prediction

## Summary Metrics

- Accuracy: **0.721**

- Precision: **0.641**

- Recall: **0.463**

- F1-score: **0.538**

- ROC-AUC: **0.801**


## Figures

- Confusion Matrix: `reports/figures/confusion_matrix.png`

- ROC Curve: `reports/figures/roc_curve.png`

- Precision-Recall Curve: `reports/figures/pr_curve.png`


## Top Features (Permutation Importance)

| feature                  |   importance_mean |   importance_std |
|:-------------------------|------------------:|-----------------:|
| Glucose                  |        0.082684   |       0.0248079  |
| Age                      |        0.0177489  |       0.0109858  |
| BMI                      |        0.0108225  |       0.01737    |
| Pregnancies              |        0.00952381 |       0.00621329 |
| DiabetesPedigreeFunction |        0.00606061 |       0.0083719  |
| BloodPressure            |        0          |       0          |
| SkinThickness            |       -0.00606061 |       0.00729537 |
| Insulin                  |       -0.00606061 |       0.00870119 |

