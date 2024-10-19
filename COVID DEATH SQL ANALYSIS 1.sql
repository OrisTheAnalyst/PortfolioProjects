SELECT location, date, total_cases, total_deaths
FROM PortfolioProject..CovidDeaths


SELECT MAX( total_cases) AS TotalCases, MAX(total_deaths) 
AS TotalDeaths, 
MAX(total_deaths)/MAX (NULLIF (total_cases,0))*100 
AS AVGDeathPercentage
FROM PortfolioProject..CovidDeaths


--TOTAL DEATH VS TOTAL CASES PERCENTAGE
--LIKELYHOOD OF DYING
SELECT location,population, date, total_cases, total_deaths, total_deaths / NULLIF (total_cases,0)*100 
AS DeathPercentage FROM PortfolioProject..CovidDeaths 
--WHERE location like '%united state%'
ORDER BY 1,2 



--LOOKING AT TOTAL CASES VS POPULATION
--PERCENTAGE OF POPULATION THAT GOT COVID
SELECT location, date, population,total_cases, total_deaths, total_cases / NULLIF (population,0)*100 
AS PopulationInfectionPercentage FROM PortfolioProject..CovidDeaths
--WHERE location like '%united kingdom%'
ORDER BY 1,2 DESC

-- COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases / NULLIF (population,0))*100 
AS HighestInfectionCountPercentage FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY HighestInfectionCountPercentage DESC

-- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


--BREAKING DOWN BY CONINENT
SELECT location, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--CONTINENT WITH HIGHEST DEATH COUNT PER POPULATION
SELECT continent, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


SELECT * FROM PortfolioProject..CovidVacinnation dea
JOIN PortfolioProject..CovidVacinnation vac
on dea.location = vac.location
and dea.date = vac.date

-- TOTAL POPULATION VS VACCINATION
SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject..CovidVacinnation dea
JOIN PortfolioProject..CovidVacinnation vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--PARTITION
SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT (INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location  ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
FROM PortfolioProject..CovidVacinnation dea
JOIN PortfolioProject..CovidVacinnation vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--USE CTE

WITH PopvsVac (continent, TotalDeathCount)
AS
(
SELECT continent, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
--ORDER BY TotalDeathCount DESC
)
SELECT *
FROM PopvsVac


CREATE TABLE ContinentTotalDeath
(continent nvarchar(255), totaldeathcount numeric)
INSERT INTO ContinentTotalDeath
SELECT continent, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent

SELECT *
FROM ContinentTotalDeath

--CREATE VIEW
CREATE VIEW Death AS
SELECT continent, MAX(total_deaths) AS TotalDeathCount 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
--ORDER BY TotalDeathCount DESC

SELECT location, date, population,MAX(total_cases) AS HighestInfectionCount,MAX( total_deaths), total_cases / NULLIF (population,0)*100 
AS PercentagePopulationInfection FROM PortfolioProject..CovidDeaths
--WHERE location like '%united kingdom%'
GROUP BY population
ORDER BY PercentagePopulationInfection

