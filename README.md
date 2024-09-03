# Social Factors and GDP: a Multivariate approach

Assessing a country's prosperity involves more than just GDP, which measures the total value of goods and services produced annually. While GDP is a key indicator, understanding how social factors influence economic growth can offer deeper insights. This project explores the impact of various social factors on GDP using multiple linear regression, aiming to construct a reliable production function.

## Data and Methods

### Data Selection
- Source: Data collected from The World Bank and OECD
- Coverage: Nearly 120 countries over a 60-year period (1960-2021)
- Variables: GDP, labor force, capital, net migration, unemployment, fertility rate, primary and secondary education, and mortality rates

### Analysis
- Preprocessing: Data cleaning, transformation, and integration to prepare a 390x10 dataset.
- Regression Models:
  - Cobb-Douglas Production Function: Linear regression on GDP, labor force, and capital.
  - Social Factors: Multivariate linear regression using social variables to assess their impact on GDP.

## Results

- Cobb-Douglas Function: Provided a high R-squared value, indicating a strong fit for GDP prediction.
- Social Factors: Identified net migration, unemployment, and secondary education as significant predictors, though residual analysis showed some limitations.

The study confirms that multiple linear regression can effectively model production functions. Social factors like net migration and education are relevant to GDP, but results may vary due to data limitations and the indirect influence of these factors on economic output.
