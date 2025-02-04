# Data-Cleaning-and-EDA-on-Layoffs-Data

## Data Cleaning
The raw dataset contained duplicate records, inconsistent data formats, and missing values, making it necessary to clean the data before analysis. To maintain data integrity, data cleaning was performed on a newly created table rather than modifying the raw dataset. The following steps were taken:

Removing Duplicate Data – Eliminated redundant records to ensure accuracy in the analysis.
Standardizing Data – Ensured consistency in data formats, such as date formats, text cases, and categorical values.
Handling Missing Values – Addressed null or blank values using appropriate imputation techniques or removal where necessary.
Removing Unnecessary Columns – Dropped columns that were irrelevant to the analysis to optimize efficiency.

## Exploratory Data Analysis (EDA)
Key Findings
1. Highest Layoff Numbers
The maximum number of employees laid off in a single event was 12,000.
The highest layoff percentage recorded was 100%, indicating that some companies completely shut down, laying off their entire workforce.
2. Industries Most Affected
The Consumer Industry experienced the highest number of layoffs, highlighting its vulnerability to market disruptions.
```
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY industry
ORDER BY 2 DESC;
```
4. Layoffs by Country
The United States recorded the highest number of layoffs, suggesting significant job market instability in the region.
```
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY country
ORDER BY 2 DESC;
```
5. Layoffs by Year
Layoffs peaked during specific years, correlating with major economic downturns such as the COVID-19 pandemic.
```
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;
```
6. Layoffs by Company Stage
Companies at different funding stages experienced layoffs at varying rates.
Later-stage startups and publicly traded companies faced more significant workforce reductions.
```
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY stage
ORDER BY 1 DESC;
```
7. Rolling Total of Layoffs (Cumulative Analysis)
A time-series analysis revealed a continuous increase in layoffs over months, highlighting critical periods of workforce reduction.
SQL Query Used:
```
WITH Rolling_Total AS (
    SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC
) 
SELECT `MONTH`, total_off,
       SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
```
8. Top 5 Companies with the Highest Layoffs in Each Year
The top 5 companies with the highest layoffs each year were identified to understand which organizations were most impacted annually.
```
WITH Company_Year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    ORDER BY 3 DESC
), Company_Year_Rank AS (
    SELECT *, DENSE_RANK () OVER (PARTITION BY YEARS ORDER BY total_laid_off DESC) AS RANKING 
    FROM Company_Year 
    WHERE YEARS IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank 
WHERE RANKING <= 5;
```
9. Companies with the Highest Layoffs Per Year
The company with the highest layoffs for each year was identified:
2020: Uber (7,525 layoffs)
2021: Bytedance
2022: Meta
2023: Google
```
WITH Company_Year (company, years, total_laid_off) AS (
    SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
    ORDER BY 3 DESC
), Company_Year_Rank AS (
    SELECT *, DENSE_RANK () OVER (PARTITION BY YEARS ORDER BY total_laid_off DESC) AS RANKING 
    FROM Company_Year 
    WHERE YEARS IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank 
WHERE RANKING = 1;
```

## Conclusion
The analysis revealed critical insights into workforce reductions across industries, countries, and company stages. The data showed:

1. Consumer Industry was the most affected.
2. The United States had the highest layoffs.
3. Layoffs peaked during economic crises such as the COVID-19 pandemic.
4. Larger companies and later-stage startups faced significant workforce reductions.
5. Some companies shut down completely, laying off 100% of their workforce.
   
These insights can help businesses and policymakers anticipate workforce challenges and develop strategies to mitigate layoffs in future economic downturns.
