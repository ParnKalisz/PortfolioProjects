SELECT *
FROM [Data Base Portflio]..CovidDeaths$
Where continent is not null
ORDER BY 3,4


--SELECT *
--FROM [Data Base Portflio]..CovidVaccinations$
--ORDER BY 3,4


-- Select Data which will be used
SELECT Location, date, total_cases, new_cases, total_deaths, population
From [Data Base Portflio]..CovidDeaths$
ORDER BY 1,2


-- Try to find out Total Cases and Total Deaths in Poland
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Data Base Portflio]..CovidDeaths$
WHERE location like '%Polan%'
ORDER BY 1,2


-- Try to find Total Cases in Population
-- Codes shows what percentage of population got a COVID-19
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PopulationCases
FROM [Data Base Portflio]..CovidDeaths$
WHERE location like '%Polan%'
ORDER BY 1,2


-- Which countroes got highest Infection Rate and compared with population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/Population)*100 AS PopulationCasesInfected
FROM [Data Base Portflio]..CovidDeaths$
GROUP BY Location, Population
ORDER BY PopulationCasesInfected desc


-- Which Countries had the highest Death Count per population
SELECT Location, MAX(cast(total_deaths AS int)) AS TotalCountryDeaths
FROM [Data Base Portflio]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalCountryDeaths desc


-- Per Continents with most deaths
SELECT Continent, MAX(cast(total_deaths AS int)) AS TotalContinentDeaths
FROM [Data Base Portflio]..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY Continent
ORDER BY TotalContinentDeaths desc


-- Global Percentage
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathGlobalPercentage
FROM [Data Base Portflio]..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 1,2


--Use CTE to make finish code below..
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From [Data Base Portflio]..CovidDeaths$ dea
JOIN [Data Base Portflio]..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100 AS PeopleVaccinated
From PopvsVac


--Use Temp Tab instead of CTE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From [Data Base Portflio]..CovidDeaths$ dea
JOIN [Data Base Portflio]..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


-- CREATING VIEW to stora data for later visualization in POWER BI TOOL
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location
, dea.Date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
From [Data Base Portflio]..CovidDeaths$ dea
JOIN [Data Base Portflio]..CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3 