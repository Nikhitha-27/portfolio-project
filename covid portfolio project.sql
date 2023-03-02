select *
from projectData..covidDeaths
order by 2,3


--select *
--from projectData..covidVaccinations


select location,date,total_cases,new_cases,total_deaths,population
from projectData..covidDeaths
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 As deathPercent
from projectData..covidDeaths
where location='india'
order by 1,2


  
  select location,date,total_cases,population,(total_cases/population)*100 As casesPercent
from projectData..covidDeaths
where location='india'
order by 1,2


select location,population,Max(total_cases) As Highestinfectedcount,max((total_cases/population))*100 As casesPercent
from projectData..covidDeaths
group by location ,population 
order by casesPercent desc

select location,population,date,Max(total_cases) As Highestinfectedcount,max((total_cases/population))*100 As casesPercent
from projectData..covidDeaths
group by location ,population ,date
order by casesPercent desc


select location, max(cast(total_deaths as int)) as totalDeathCount
 from projectData..covidDeaths
 --where continent is not null
 group by location
 order by totalDeathCount desc


 select continent, max(cast(total_deaths as int)) as totalDeathCount
 from projectData..covidDeaths
 where continent is not null
 group by continent
 order by totalDeathCount desc


 select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercent
 from projectData..covidDeaths
 where continent is not null
 order by 1,2 
 
with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as (

 select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))Over(partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
 from  projectData..covidDeaths dea
 join projectData..covidVaccinations vac
 on dea.location=vac.location
   and dea.date=vac.date
  where dea.continent is not null

  )
   select * ,(RollingPeopleVaccinated/population)*100 
   from PopvsVac
   drop table if exists  #percentPopulationVaccinated
   create Table #percentPopulationVaccinated
   ( continent nvarchar(255),
      location nvarchar(255),
	  date datetime,
	  population numeric,
	  new_vaccinations numeric,
	  RollingPeopleVaccinated numeric
	  )

	  insert into #percentPopulationVaccinated
	  
	    select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))Over(partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
           from  projectData..covidDeaths dea
           join projectData..covidVaccinations vac
           on dea.location=vac.location
          and dea.date=vac.date
         --where dea.continent is not null
		 select * ,(RollingPeopleVaccinated/population)*100 
            from #percentPopulationVaccinated
			  


 create view percentPopulationVaccinated as
	  
	    select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations))Over(partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
           from  projectData..covidDeaths dea
           join projectData..covidVaccinations vac
           on dea.location=vac.location
          and dea.date=vac.date
         where dea.continent is not null


		 select *
		 from percentPopulationVaccinated 