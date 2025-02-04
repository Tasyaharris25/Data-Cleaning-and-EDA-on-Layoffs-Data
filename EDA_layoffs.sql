-- Exploratory Data Analysis 

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_Off), MAX(percentage_laid_off)
FROM layoffs_staging2 ;

-- the company that completely went under since the laid off all the employees
SELECT *
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY industry
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2 ;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY country
ORDER BY 2 DESC;

DELETE
from layoffs_staging2
where year(`date`) is null; 

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2 
GROUP BY stage
ORDER BY 1 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2 
GROUP BY company 
ORDER BY 2 DESC;

-- Rolling the total of laid off 

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) 
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


SELECT * 
FROM layoffs_staging2;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
) 
SELECT `MONTH`, total_off,
	SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- per company
SELECT company, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- per company per year 

WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
)
SELECT * , DENSE_RANK () OVER (PARTITION BY YEARS ORDER BY total_laid_off DESC) AS RANKING 
FROM Company_Year 
WHERE YEARS IS NOT NULL
ORDER BY RANKING ASC;

-- rank 5
WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(SELECT * , DENSE_RANK () OVER (PARTITION BY YEARS ORDER BY total_laid_off DESC) AS RANKING 
FROM Company_Year 
WHERE YEARS IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank 
WHERE RANKING <= 5;

-- company with highest total laid off in each year
WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(SELECT * , DENSE_RANK () OVER (PARTITION BY YEARS ORDER BY total_laid_off DESC) AS RANKING 
FROM Company_Year 
WHERE YEARS IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank 
WHERE RANKING = 1


