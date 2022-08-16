--*************************************************************************************************************************

select * from [vasu project 1]..CovidDeaths

select * from [vasu project 1]..CovidVaccination



--------------------------------------------------------------------------------------------------------------------------


select location, date , new_cases,total_cases,total_deaths,population
from [vasu project 1]..CovidDeaths



--------------------------------------------------------------------------------------------------------------------------


-- total death percentages in india 
select location, date,total_cases,total_deaths,population,(total_deaths/total_cases)*100 as total_death_percentage
from [vasu project 1]..CovidDeaths
 where location = 'india'
 

--------------------------------------------------------------------------------------------------------------------------



 -- Countries with Highest Infection Rate compared to Population

 select location, population, max (total_cases) as Heighest_infected,max((total_cases/population))*100 as total_population_infected
from [vasu project 1]..CovidDeaths
Group by location,population
order by total_population_infected desc 



--------------------------------------------------------------------------------------------------------------------------


 -- Countries with Highest Death Count per Population

  select location, max (total_deaths) as Heighest_death_count, max((total_deaths/population))*100 as total_death_count
from [vasu project 1]..CovidDeaths
Group by location
order by total_death_count desc 



--------------------------------------------------------------------------------------------------------------------------


-- showing  continent with heighest death count

  select continent, max(cast (total_deaths as int)) as Heighest_death_count
from [vasu project 1]..CovidDeaths
where continent is not null
Group by continent
order by Heighest_death_count desc
 

--------------------------------------------------------------------------------------------------------------------------


 -- Global numbers on total cases and total death percentages date wise

select date,sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from [vasu project 1]..CovidDeaths 
where continent is not null
group by date
order by date  



--------------------------------------------------------------------------------------------------------------------------



--  total cases and total death percentages  in the world


select sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from [vasu project 1]..CovidDeaths 
order by 1
 
 

--------------------------------------------------------------------------------------------------------------------------


 -- joining both the tables

select *
from [vasu project 1]..CovidDeaths as a 
left join [vasu project 1]..CovidVaccination as b on a.location = b.location  



--------------------------------------------------------------------------------------------------------------------------


-- looking at total population vs total vaccination


select sum(a.population) , b.total_vaccinations
from [vasu project 1]..CovidDeaths as a 
left join [vasu project 1]..CovidVaccination as b on a.location = b.location 
--where a.continent is not null
group by a.population



--------------------------------------------------------------------------------------------------------------------------


-- looking at total population vs total vaccination in percentage
-- Using CTE to perform Calculation on Partition By in previous query



with population_vs_vaccination (continent, location, date,population, new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [vasu project 1]..CovidDeaths dea
Join [vasu project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as vaccinated_people_percentage from Percentage_Population_Vaccinated



-- Using Temp Table to perform Calculation on Partition By in previous query


--------------------------------------------------------------------------------------------------------------------------



DROP Table if exists #Percentage_Population_Vaccinated

create table #Percentage_Population_Vaccinated
(
continent nvarchar(255),
location nvarchar(255), 
date datetime , 
population numeric , 
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #Percentage_Population_Vaccinated


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [vasu project 1]..CovidDeaths dea
Join [vasu project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100 as vaccinated_people_percentage from #Percentage_Population_Vaccinated



--------------------------------------------------------------------------------------------------------------------------


-- Creating View to store data for later visualizations

create view  a_Percentage_Population_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [vasu project 1]..CovidDeaths dea
Join [vasu project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


create view covid_world_data as

select sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from [vasu project 1]..CovidDeaths 



------------------------------------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx------------------------------------------






































































