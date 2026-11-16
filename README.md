# HR Attrition & Workforce Analytics

An end-to-end analytics project using **Excel, MySQL, Python and Power BI** to understand workforce distribution and employee attrition.

> **Data disclaimer:** This project uses the *IBM HR Analytics Employee Attrition & Performance* dataset, a publicly available **simulated** dataset. It is **not real company data**. All findings describe this simulated dataset only.

---

## 1. Project Overview

An HR team wants to understand where employees leave and which employee groups show higher attrition. This project answers:

1. How many employees are in each department?
2. What is the attrition rate by department and job role?
3. How does attrition vary by tenure and age group?
4. How are overtime, salary band and satisfaction related to attrition?
5. Which **groups** (segments) have the highest attrition rates?

## 2. Tools Used

| Tool | Purpose |
|---|---|
| Excel | Data checks, cleaning, helper columns, summary formulas |
| MySQL Workbench | SQL analysis (headcount, attrition rate, segments) |
| Python (pandas, NumPy, Matplotlib, Seaborn) | Validation, exploratory analysis, charts, exports |
| Power BI Desktop | 3-page interactive dashboard with DAX measures |
| GitHub | Documentation and portfolio |

## 3. Dataset

- **Source:** IBM HR Analytics Employee Attrition & Performance (Kaggle, publicly available, simulated). Check the dataset page for its license before reuse.
- **Size:** 1,470 employees, 35 original columns (36 after cleaning).
- **Outcome column:** `Attrition` (Yes = left, No = active).
- **Main fields used:** `Department`, `JobRole`, `Age`, `YearsAtCompany`, `MonthlyIncome`, `OverTime`, `JobSatisfaction`, `WorkLifeBalance`, `EnvironmentSatisfaction`.

**Cleaning and helper columns**

- Checked missing values (0), duplicate rows (0) and category spelling.
- Removed 3 constant columns: `EmployeeCount`, `Over18`, `StandardHours`.
- Created `Attrition_Flag` (Yes = 1, No = 0), `Age_Group`, `Tenure_Group` and `Salary_Band`.

| Helper column | Groups (my own choices, not official standards) |
|---|---|
| `Age_Group` | 18-25, 26-35, 36-45, 46-55, 56+ |
| `Tenure_Group` (`YearsAtCompany`) | 0-1, 2-5, 6-10, 11-20, 20+ years |
| `Salary_Band` (`MonthlyIncome`) | Low (<3000), Medium (3000-5999), High (6000-9999), Very High (10000+) |

**Key definitions**

- **Headcount** = number of employees in a group.
- **Attrition count** = number of those employees who left.
- **Attrition rate** = attrition count ÷ headcount of the same group.

## 4. Methodology

1. **Excel:** inspected the data, removed constant columns, created helper columns, built summary formulas, and checked results.
2. **SQL (MySQL):** loaded the cleaned data into a table, then wrote `GROUP BY` queries for headcount, attrition rate, tenure, age, overtime, salary band, satisfaction and segments.
3. **Python:** validated the data, built a reusable summary function, created 11 charts, calculated correlations, and exported tables for Power BI.
4. **Power BI:** built a 3-page dashboard with DAX measures, slicers and different chart types.
5. **Cross-checking:** the same headline numbers (1,470 employees, 237 left, 16.12%) were confirmed in Excel, SQL, Python and Power BI.

## 5. Key Findings

Overall: **1,470 employees, 237 left, 1,233 active, attrition rate 16.12%.**

| Area | What the data shows | Headcount (n) |
|---|---|---|
| Department | Sales **20.63%**, HR 19.05%, R&D 13.84% | 446 / 63 / 961 |
| Job role | Sales Representative **39.76%** (highest), Research Director 2.50% (lowest) | 83 / 80 |
| Tenure | 0-1 years **34.88%**, 11-20 years 6.67% | 215 / 180 |
| Age | 18-25 **35.77%**, 36-45 9.19% | 123 / 468 |
| Overtime | Yes **30.53%** vs No 10.44% | 416 / 1,054 |
| Salary band | Low **28.61%**, Very High 8.90% | 395 / 281 |
| Job satisfaction | Level 1 (Low) 22.84%, Level 4 (Very High) 11.33% | 289 / 459 |
| Work-life balance | Level 1 (Bad) 31.25% | 80 |

**High-attrition segments** (groups with at least 30 employees):

- Overtime = Yes and 0-1 years tenure: **55.07%** (69 employees).
- Age 18-25 and overtime = Yes: **64.10%** (39 employees).
- R&D, overtime = Yes, Low salary band: **52.87%** (87 employees).

**Why it may matter to HR, and what could be considered**

| Insight | Possible action for HR to consider |
|---|---|
| Attrition is much higher in the first year | Review onboarding and early-career support |
| Overtime is associated with a much higher attrition rate | Review workload and overtime practices |
| The lowest pay band has the highest attrition rate | Review pay for low-band roles |
| Sales Representatives show the highest role-level rate | Investigate role expectations and targets |

## 6. Dashboard (Power BI)

A 3-page interactive report. Open `05_powerbi/HR_Attrition_Dashboard.pbix` in Power BI Desktop (Windows).

| Page | Content |
|---|---|
| 1. Overview | KPI cards (total, active, left, attrition rate), donut, treemap, 100% stacked bar, headcount by age and tenure |
<img width="883" height="498" alt="Screenshot 2026-11-16 133716" src="https://github.com/user-attachments/assets/4003bfa3-dbe3-4283-9962-10f51f5f813e" />

| 2. Attrition Analysis | Job role bar, tenure combo chart, age column, salary 100% stacked bar, overtime column, waterfall of leavers by department |
<img width="893" height="497" alt="Screenshot 2026-11-16 133749" src="https://github.com/user-attachments/assets/9c1738a2-f888-4f0c-8ea6-c6e91e0e5b7c" />

| 3. Insights | Overtime × tenure heatmap matrix, decomposition tree, small multiples by overtime, work-life balance bar, pay vs attrition bubble scatter, recommendations |
<img width="884" height="499" alt="Screenshot 2026-11-16 133806" src="https://github.com/user-attachments/assets/358f6523-54d8-4946-8136-13bb0e74f1fd" />





**Key DAX measures**

```DAX
Total Employees = COUNTROWS(Employees)
Employees Left = SUM(Employees[Attrition_Flag])
Active Employees = [Total Employees] - [Employees Left]
Attrition Rate = DIVIDE([Employees Left], [Total Employees], 0)
Overall Attrition Rate = DIVIDE(CALCULATE([Employees Left], ALL(Employees)), CALCULATE([Total Employees], ALL(Employees)))
Segment Rate (min 30) = IF([Total Employees] >= 30, [Attrition Rate], BLANK())
```

## 7. Python Charts

Charts created by `04_python/hr_attrition_analysis.py` are saved in `06_docs/charts/`



## 8. How to Reproduce

**Python**
```bash
pip install -r requirements.txt
cd 04_python
python hr_attrition_analysis.py
```
The script reads `02_cleaned_data/HR_Attrition_Cleaned.csv`, then writes charts to `06_docs/charts/` and Power BI tables to `05_powerbi/`.

**SQL**
1. Open MySQL Workbench and create a database named `hr_analytics`.
2. Load the cleaned CSV into a table named `employees`.
3. Run the queries in `03_sql/02_analysis_queries.sql` one at a time.

**Power BI**
1. Open `05_powerbi/HR_Attrition_Dashboard.pbix`.
2. If the data source path is different on your computer, use **Home → Transform data → Data source settings**.

## 9. Project Structure

```
hr-attrition-workforce-analytics/
├── README.md
├── requirements.txt
├── .gitignore
├── 01_raw_data/            original IBM CSV (add only if the dataset license allows)
├── 02_cleaned_data/        HR_Attrition_Cleaned.csv, HR_Attrition_Cleaned.xlsx
├── 03_sql/                 01_create_and_load_employees.sql, 02_analysis_queries.sql
├── 04_python/              hr_attrition_analysis.py, 01_hr_attrition_analysis.ipynb
├── 05_powerbi/             HR_Attrition_Dashboard.pbix
└── 06_docs/
    ├── screenshots/        Power BI page screenshots
    ├── HR_Attrition_Project_Documentation.pdf
    └── HR_Attrition_Project.pptx
```

## 10. Limitations

- **Single snapshot:** the dataset has no hire dates or exit dates, so **hiring-versus-exit and monthly or quarterly trends were not built**. Tenure charts show a profile by tenure group, not a trend over time.
- **Simulated data:** patterns may differ from real organizations.
- **Associations, not causes:** overtime, pay and satisfaction are linked with attrition rates here, but this analysis cannot show that they cause people to leave.
- **Group-level only:** no predictive model was built, so no individual employee is labelled "high risk". Results describe **high-attrition segments**.
- **Small groups:** rates for small groups (for example HR with 63 employees) can change a lot with a few people. Segment analysis uses groups of at least 30 employees.
- **Own band definitions:** the age, tenure and salary groups are my own choices.

## 11. Possible Future Work

- Add a dataset with hire and exit dates to build a hiring-vs-exits trend page.
- Test a validated predictive model, with proper train/test evaluation, before any individual-level risk scoring.
- Add statistical tests for group differences.

## 12. Author

**KARTHIKA K**
