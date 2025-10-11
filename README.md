# relsurv_rme_calle_11_20_chile: SUPERVIVENCIA RELATIVA DE PERSONAS EN PROGRAMA DE POBLACIÓN EN SITUACIÓN DE CALLE, SENDA, 2011-2020, CHILE

This repository contains all the **R** and **Quarto** files used for the epidemiological analysis and poster presentation on the Relative Survival & $\text{RME}$ (*Relative Mortality Excess*) of individuals participating in the Program between 2011 and 2020.

## Poster Presentation Details

This work was presented as a poster at a major national conference:

* **Conference:** VIII Congreso Chileno de Salud Pública & X Congreso Chileno de Epidemiología
* **Topic:** SUPERVIVENCIA RELATIVA DE PERSONAS EN PROGRAMA DE POBLACIÓN EN SITUACIÓN DE CALLE, SENDA, 2011-2020, CHILE

---

## Project Goal and Methodology

The primary objective of this project was to apply **relative survival analysis** to a highly vulnerable population in Chile to accurately estimate mortality compared to the general population (measured by the excess mortality rate).

* **Key Methodology:** Relative Survival Analysis using the `relsurv` R package.
* **Data Source:** Programmatic data from the Chilean National Service for the Prevention and Rehabilitation of Drug and Alcohol Consumption (SENDA), linked to mortality records (DEIS).

---

## 📁 Repository Structure

The files below document the analysis pipeline and presentation output:

| File / Folder | Description |
| :--- | :--- |
| `CongresoSPEPI.qmd` | **Quarto document** containing the R code, text, and layout for the primary poster version. |
| `CongresoSPEPI2.qmd` | **Quarto document** for BYM2 models for regional excess mortality risk. |
| `E-Poster.pptx` | **Power Point** poster presentation. |
| `README.md` | This file. |

**Note:** Raw, individual-level sensitive data is *not* uploaded here for privacy reasons.

---

## AUTHORS AND AFFILIATION

Name: Álvaro Castillo-Carniglia
Affiliation: PhD in Public Health. Department of Public Health, Facultad de Medicina y Ciencia, Universidad San Sebastián, Chile
Contact: alvacasti@gmail.com
ORCID: 0000-0002-3016-890X

Name: Andrés González-Santa Cruz
Affiliation: Ph.D. student, Public Health, UCH, Chile
Contact: gonzalez.santacruz.andres@gmail.com
ORCID: 0000-0002-5166-9121

## 🤝 Acknowledgements

We extend our gratitude to the following individuals and institutions for their invaluable support and contributions to this project:

- Núcleo Milenio para la Evaluación y Análisis de Políticas de Drogas (nDP) (Millennium Nucleus for the Evaluation and Analysis of Drug Policy

- SENDA (Servicio Nacional para la Prevención y Rehabilitación del Consumo de Drogas y Alcohol)

- DEIS (Departamento de Estadísticas e Información de Salud)


## ⚙️ Reproducibility and Setup

To run the analysis scripts and render the posters yourself, you'll need the following environment:

### 1. Prerequisites

* **R** (4.1.2)
* **RStudio** (highly recommended for ease of use)
* **Quarto CLI** (usually bundled with RStudio or installable separately)

### 2. Required R Packages

The analysis relies on specialized packages for survival statistics. Install them using the following R code:

```r
if(!require(pacman)){install.packages("pacman");require(pacman)}

# Install essential packages
# Note: INLA requires separate installation from its dedicated repository.
pacman::p_load(
    # Package Management
    pacman,       # Streamlines loading and installing packages simultaneously
    
    # Core Data & Visualization (Part of tidyverse)
    tidyverse,    # Collection of packages for data manipulation, visualization, and more
    dplyr,        # Grammar of data manipulation (e.g., filter, mutate, group_by)
    tidyr,        # Tools for tidying data, reshaping (e.g., pivot_wider, pivot_longer)
    ggplot2,      # Grammar of graphics for powerful data plotting
    stringr,      # Consistent wrappers for common string manipulation tasks
    purrr,        # Tools for working with functions and vectors/lists (e.g., mapping)
    viridisLite,  # Provides the perceptually uniform 'viridis' color palettes
    scales,       # Graphical scales for ggplot2 (e.g., custom breaks, formatting labels for axes)
    
    # Survival & Epidemiology
    mexhaz,       # Flexible parametric hazard regression models for survival analysis
    relsurv,      # Core package for **Relative Survival Analysis** in population-based studies
    survminer,    # Extends 'survival' for high-quality Kaplan-Meier plots and survival tables
    popEpi,       # Tools for standardized mortality ratios (SMRs) and population-level survival measures
    epitools,     # Epidemiological tools for data analysis (e.g., rate ratios, exact confidence intervals)
    
    # Spatial Analysis
    sf,           # Simple Features: for handling and analyzing **vector-based spatial data** (points, lines, polygons)
    spdep,        # Spatial dependence: for analyzing spatial autocorrelation and spatial regression models
    geodata,      # Access to global spatial data (e.g., administrative boundaries, climate data)
    INLA,         # Integrated Nested Laplace Approximations (Bayesian spatial modeling) - install separately
    
    # Data Cleaning & Reporting
    janitor,      # Simple tools for examining and cleaning dirty data (e.g., cleaning column names)
    tableone,     # Creates "Table 1" summaries for descriptive statistics (baseline characteristics)
    kableExtra,   # Enhances 'knitr::kable()' for complex and professional R Markdown tables
    pander,       # A tool for rendering R objects into Pandoc markdown formats
    DT,           # Creates interactive HTML data tables (useful for detailed tables in R Markdown/Quarto)
    rio,          # Simplifies data import/export with a consistent interface ('import()')
    quarto,       # For rendering the R Markdown/Quarto poster documents (.qmd files)
    
    # Statistical & Computing Tools
    biostat3,     # Functions and datasets for biostatistics teaching and research
    coin,         # Conditional inference procedures for robust hypothesis testing (e.g., permutation tests)
    metafor,      # For heterogeneity testing and general **meta-analysis** methods
    parallel,     # Base R package for **parallel computing** (useful for speeding up bootstrap and resampling)
    cowplot,      # Streamlined plot theme and functions for arranging multiple ggplot2 plots
    grid,         # Base R package for low-level graphics (used indirectly for plot arrangement)
    ellmer,       # Commonly used for likelihood estimation or generalized mixed-effects models (LMM/GLMM)
    
    # Development & Reproducibility Tools
    devtools,     # Tools to make package development easier (often used to install from GitHub)
    installr,     # Functions for self-updating R and R packages
    liftr,        # A framework for creating and managing reproducible research projects
    pak,          # A fast, dependency-aware package installer (alternative to install.packages)
    
    install = TRUE
)

# Remember to install INLA from its specific repository:
# install.packages("INLA", repos=c(getOption("repos"), INLA='https://inla.r-inla-download.org/R/stable'), dep = TRUE)
```
