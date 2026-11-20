# 📊 E-commerce Sales EDA in R

![R](https://img.shields.io/badge/R-276DC3?logo=r&logoColor=white)
![tidyverse](https://img.shields.io/badge/tidyverse-dplyr_%7C_ggplot2-1A162D)
![testthat](https://img.shields.io/badge/testthat-unit_tests-6E9F18)
![CI](https://github.com/asad110abbas/r-sales-eda/actions/workflows/ci.yml/badge.svg)

**Exploratory data analysis** of two years of e-commerce orders using the **tidyverse**: revenue trends,
category mix, price distributions, seasonality heatmaps and the effect of discounts on customer ratings.

## Questions explored
1. How is monthly revenue trending, and how volatile is month-over-month growth?
2. Which categories drive revenue, and what is their average order value?
3. How are prices distributed within each category (log scale)?
4. Which months and weekdays are strongest (heatmap)?
5. Do bigger discounts actually make customers happier?

## Output
`Rscript run.R` prints summary tables and saves five publication-quality charts to `figures/`:

| File | Chart |
|---|---|
| `01_monthly_revenue.png` | Area + line with LOESS trend |
| `02_category_share.png` | Ranked bar with % share labels |
| `03_price_distribution.png` | Density by category, log-scaled x-axis |
| `04_weekday_heatmap.png` | Month × weekday revenue heatmap |
| `05_discount_vs_rating.png` | Boxplot of rating by discount level |

## Run
```r
install.packages(c("dplyr", "ggplot2", "lubridate", "tidyr", "scales", "testthat"))
```
```bash
Rscript run.R
Rscript tests/testthat.R
```

## Structure
```
R/generate_data.R   synthetic, seeded order generator
R/analysis.R        pure summary functions + ggplot2 report
run.R               entry point
tests/testthat/     unit tests for the summary functions
```

> The data is synthetic.
