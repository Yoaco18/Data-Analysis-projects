
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` double DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2. Insertar evaluando TODAS las columnas para detectar duplicados exactos
INSERT INTO layoffs_staging2
SELECT 
  company,
  location,
  industry,
  total_laid_off,
  percentage_laid_off,
  `date`,
  stage,
  country,
  funds_raised_millions,
  ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, 
                 percentage_laid_off, `date`, stage, country, funds_raised_millions
  ) AS row_num
FROM layoffs_staging;

-- 3. Eliminar únicamente las filas verdaderamente duplicadas
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- 4. Opcional: Eliminar la columna auxiliar al finalizar la limpieza
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

update layoffs_staging2
set country = "United States"
where country like "United States."
;

update layoffs_staging2
set `date` = str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date; 

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null)
and t2.industry is not null;

delete
from layoffs_staging2
Where total_laid_off is null
and percentage_laid_off is null;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

select * 
from layoffs_staging2;
        
SELECT company, location, industry, total_laid_off, 
       percentage_laid_off, `date`, stage, country, funds_raised_millions, 
       COUNT(*) AS total_duplicados
FROM layoffs_staging2
GROUP BY company, location, industry, total_laid_off, 
         percentage_laid_off, `date`, stage, country, funds_raised_millions
HAVING COUNT(*) > 1;

select * 
from layoffs_staging2
order by company asc;

        
SELECT *
FROM layoffs_staging2
WHERE company IN (
    SELECT company
    FROM layoffs_staging2
    GROUP BY company
    HAVING COUNT(*) > 1
)
ORDER BY company ASC, `date` ASC;

        
        
        
        
        
        