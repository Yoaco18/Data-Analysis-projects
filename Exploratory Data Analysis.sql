-- Exploratory Data Analysis

select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company, SUM(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;

select MIN(`date`), MAX(`date`)
from layoffs_staging2;

select industry, SUM(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc
;

select *
from layoffs_staging2;

select year (`date`), SUM(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc
;


select stage, SUM(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc
;

select company, AVG(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;

Select substring(`date`,1,7) as `Month`, sum(total_laid_off) 
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc;

with rolling_total as 
(Select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `Month`
order by 1 asc)
select `Month`, total_off,
sum(total_off) over(order by `Month`) as rolling_total
from rolling_total;



select company, SUM(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;


select company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;

with company_year (company, years, total_laid_off) as
(select company, year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
), company_year_rank as 
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5;


with industry_year (industry, years, total_laid_off) as
(select industry, year(`date`), SUM(total_laid_off)
from layoffs_staging2
group by industry, year(`date`)
), industry_year_rank as 
(
select *, dense_rank() over (partition by years order by total_laid_off desc) as ranking
from industry_year
where years is not null
)
select *
from industry_year_rank
where ranking <= 5;







