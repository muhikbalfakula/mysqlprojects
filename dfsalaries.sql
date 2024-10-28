select * from ds_salaries;

-- 1. Apakah ada data yang NULL
select * from ds_salaries 
where work_year is null
or experience_level is null
or employment_type is null
or job_title is null
or salary is null
or salary_currency is null
or salary_in_usd is null
or employee_residence is null
or remote_ratio is null
or company_location is null
or company_size is null;

-- 2. Melihat job title ada apa saja
select distinct job_title from ds_salaries order by job_title;

-- 3. Job title apa saja yang berkaitan dengan data analyst
select distinct job_title from ds_salaries where job_title like '%data analyst%' order by job_title ;

-- 4. rata-rata gaji data analyst
select (avg(salary_in_usd) * 15000) / 12 as avg_salary_in_rupiah from ds_salaries;

-- 5. rata rata gaji data analyst berdasarkan experience levelnya
select experience_level, (avg(salary_in_usd) * 15000) / 12 as avg_salary_in_rupiah from ds_salaries group by experience_level;

-- 6. rata rata gaji data analyst berdasarkan experience levelnya dan jenis employment type nya
select employment_type, experience_level, (avg(salary_in_usd) * 15000) / 12 as avg_salary_in_rupiah from ds_salaries group by experience_level, employment_type order by experience_level, employment_type;


-- 7. negara dengan gaji yang menarik untuk posisi data analyst, full time, exp kerjanya entry level dan menengah
select company_location, avg(salary_in_usd) 
as avg_sal_in_usd from ds_salaries 
where job_title like '%data analyst%' 
and employment_type = 'FT' 
and experience_level in ('MI', 'EN') 
group by company_location 
having avg_sal_in_usd >= 20000;

-- 8. di tahun ke berapa kenaikan gaji dari mid ke senior memiliki kenaikan yang tertinggi (untuk pekerjaan yang berkaitan dengan data analyst , penuh waktu)
with ds_1 as (
select work_year,
avg(salary_in_usd) as sal_in_usd_ex
from ds_salaries
where
	employment_type = 'FT'
    and experience_level = 'EX'
    and job_title like '%data analyst%'
group by work_year
), ds_2 as (
select work_year,
avg(salary_in_usd) as sal_in_usd_mi
from ds_salaries
where
	employment_type = 'FT'
    and experience_level = 'MI'
    and job_title like '%data analyst%'
group by work_year
), t_year as (
select distinct work_year
from ds_salaries
)
 select t_year.work_year, ds_1.work_year, ds_1.sal_in_usd_ex, ds_2.sal_in_usd_mi,
ds_1.sal_in_usd_ex - ds_2.sal_in_usd_mi differences
 from t_year 
 left join ds_1 on ds_1.work_year = t_year.work_year
 left join ds_2 on ds_2.work_year = t_year.work_year;