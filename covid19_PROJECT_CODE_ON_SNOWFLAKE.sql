USE "COVID_PORTFOLIO_PROJECT";

DROP TABLE COVIDDEATH;

create table covidDeath(
iso_code varchar(50),
continent	varchar(50),
location	varchar(50),
datE         date,
population	 int,
total_cases	VARCHAR(50),
new_cases	VARCHAR(50),
new_cases_smoothed	VARCHAR(50),
total_deaths	int
new_deaths	VARCHAR(50),
new_deaths_smoothed	VARCHAR(50),
total_cases_per_million	VARCHAR(50),
new_cases_per_million	VARCHAR(50),
new_cases_smoothed_per_million	VARCHAR(50),
total_deaths_per_million	VARCHAR(50),
new_deaths_per_million	VARCHAR(50),
new_deaths_smoothed_per_million VARCHAR(50),
reproduction_rate	VARCHAR(50),
icu_patients	varchar(50),
icu_patients_per_million VARCHAR(50),
hosp_patients	 varchar(50),
hosp_patients_per_million	varchar(50),
weekly_icu_admissions	VARCHAR(50),
weekly_icu_admissions_per_million	varchar(50),
weekly_hosp_admissions	varchar(50),
weekly_hosp_admissions_per_million varchar(50));

SELECT*FROM COVIDDEATH;

2ndtable;

drop table COVID_VACCINATION;

CREATE TABLE COVID_VACCINATION(iso_code	VARCHAR(50),
continent	VARCHAR(50),
location	VARCHAR(50),
date	DATE,
new_tests	INT,
total_tests	INT,
total_tests_per_thousand	VARCHAR(50),
new_tests_per_thousand	VARCHAR(50),
new_tests_smoothed	VARCHAR(50),
new_tests_smoothed_per_thousand	VARCHAR(50),
positive_rate	VARCHAR(50),
tests_per_case	VARCHAR(50),
tests_units	VARCHAR(50),
total_vaccinations	VARCHAR(50),
people_vaccinated	VARCHAR(50),
people_fully_vaccinated	VARCHAR(50),
new_vaccinations	VARCHAR(50),
new_vaccinations_smoothed	VARCHAR(50),
total_vaccinations_per_hundred	VARCHAR(50),
people_vaccinated_per_hundred	VARCHAR(50),
people_fully_vaccinated_per_hundred	VARCHAR(50),
new_vaccinations_smoothed_per_million	VARCHAR(50),
stringency_index	VARCHAR(50),
population_density	VARCHAR(50),
median_age VARCHAR(50),
aged_65_older	VARCHAR(50),
aged_70_older	VARCHAR(50),
gdp_per_capita	VARCHAR(50),
extreme_poverty VARCHAR(50),
cardiovasc_death_rate	VARCHAR(50),
diabetes_prevalence	VARCHAR(50),
female_smokers VARCHAR(50),
male_smokers	VARCHAR(50),
handwashing_facilities	VARCHAR(50),
hospital_beds_per_thousand	VARCHAR(50),
life_expectancy	VARCHAR(50),
human_development_index VARCHAR(50));


`-ANALYSING_Total_case_vs_TOTAL_DEATH_AND_DEATH_PERCENTAGE`;

SELECT LOCATION,date, TOTAL_CASES,TOTAL_DEATHS, (TOTAL_DEATHS/TOTAL_CASES)*100 AS DEATH_PERCENTAGE
FROM COVIDDEATH
WHERE LOCATION = 'India'
ORDER BY 1,2,3;

ANALYZING_TOTAL_CASES_VS POPULATION=========
also_showing_pouplation_Percentage_got_covid;

SELECT LOCATION,date,population, TOTAL_CASES,(total_cases/population)*100 as POPULATION_PRCRNTAGE_GOT_COVID
FROM COVIDDEATH
WHERE LOCATION = 'India'
ORDER BY 1,2;

country_have_max_cases_according_population  maximum infection rate country wise;

SELECT LOCATION,population, max(TOTAL_CASES)  as max_cases, max((total_cases/population)*100) as MAX_INFECTED_RATE_PERCENTAGE
FROM COVIDDEATH
group by 1,2
order by MAX_INFECTED_RATE_PERCENTAGE desc ;



country highest death_count per population;

SELECT LOCATION,population, max(TOTAL_deaths )  as max_deaths, max((total_deaths/population)*100) as max_death_rate_percentage
FROM COVIDDEATH
group by 1,2
order by max_death_rate_percentage desc ;


continent wise max_ death;

SELECT continent, max(TOTAL_deaths ) as max_deaths
FROM COVIDDEATH
where continent is not null
group by 1
order by continent  ;

date wise new cases and death;

select date, sum(new_cases), sum(new_deaths)
from coviddeath
group by 1
order by 1 desc;



total_population_vaccination;

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
from covidDeath dea
join COVID_VACCINATION vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;


new way=====here i also sum new vaccination;   
cte_use;

here we try to find 'allpeoplevaccinated' clm and make it in cte table then in new query we divideV/population to find vacination percentamge in country;

with popvsvac  
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location) as allpeoplevaccinated
from covidDeath dea
join COVID_VACCINATION vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
) 
select continent, location ,date, population, allpeoplevaccinated, (allpeoplevaccinated/population)*100 as PERCENTAGE_VACINATED_PEOPLE
from popvsvac;
  


how_TO_CREATE_TEMPOEARY_TABLE__;


drop table TOTAL_VACINATED;

create table TOTAL_VACINATED(
continent  varchar(200), 
  location varchar(200) ,
  date date, 
  population int, 
  new_vaccinations int,
  allpeoplevaccinated int
);



insert into  TOTAL_VACINATED
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location) as allpeoplevaccinated
from covidDeath dea
join COVID_VACCINATION vac
on dea.location = vac.location
and dea.date = vac.date;


select continent, location, date, population,allpeoplevaccinated ,
(allpeoplevaccinated/population)*100 as PERCENTAGE_VACINATED_PEOPLE 
from TOTAL_VACINATED;