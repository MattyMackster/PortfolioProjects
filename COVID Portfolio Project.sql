--SELECT *
--From ProjectPortfolio..CovidDeaths
--Where continent is not null
--ORDER BY 3,4

--select *
--from ProjectPortfolio..CovidVaccinations
--order by 3,4

--Select location, date, total_cases, new_cases, total_deaths, population
--from ProjectPortfolio..CovidDeaths
--order by 1,2




--total cases vs total deaths

--Select location, date, total_cases, new_cases, total_deaths,(total_deaths/total_cases) *100 as DeathPercentage
--from ProjectPortfolio..CovidDeaths
--Where location like '%canada%'
--order by 1,2




--looking at total cases vs population
--shows population that got Covid

--Select location, date, Population, total_cases, (total_cases/population) *100 as populationinfectedPercentage
--from ProjectPortfolio..CovidDeaths
----Where location like '%canada%'
--order by 1,2


--looking at countries with Highest Infection Rate compared to population

--Select Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population) *100 as InfectionPercentage
--from ProjectPortfolio..CovidDeaths
--Group by Location, Population
--order by InfectionPercentage desc




--Showing Countries with Highest Death Count per Population

--Select Location, MAX(total_cases) AS TotalDeathCount
--from ProjectPortfolio..CovidDeaths
--Where continent is not null
--Group by Location
--order by TotalDeathCount desc


--LET'S BREAK IT DOWN BY CONTITNETS

--Select location, MAX(total_cases) AS TotalDeathCount
--From ProjectPortfolio..CovidDeaths
--Where continent is null
--Group by location
--order by TotalDeathCount desc




--Showing continents with the Highest Death Count per population
--Select location, MAX(total_cases) AS TotalDeathCount
--From ProjectPortfolio..CovidDeaths
--Where continent is null
--Group by location
--order by TotalDeathCount desc





--GLOBAL NUMBERS

----per day

--Select date, SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
-- (new_cases)*100 as DeathPercentage
--from ProjectPortfolio..CovidDeaths
--Where continent is not null
--Group by date
--order by 1,2


----altogether

--Select SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
-- (new_cases)*100 as DeathPercentage
--from ProjectPortfolio..CovidDeaths
--Where continent is not null
--order by 1,2







--Looking at Total Population vs Vaccination

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxed
--From ProjectPortfolio..CovidDeaths dea
--Join ProjectPortfolio..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
--Order by 1,2,3

--USE CTE 

--With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaxed)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxed
--From ProjectPortfolio..CovidDeaths dea
--Join ProjectPortfolio..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
--)
--Select *
--From PopvsVac





--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxed
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaxed
From ProjectPortfolio..CovidDeaths dea
Join ProjectPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null


	Select *
	from PercentPopulationVaccinated
