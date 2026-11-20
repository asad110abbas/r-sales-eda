# Entry point: Rscript run.R
source("R/generate_data.R")
source("R/analysis.R")

orders <- generate_orders()
results <- run_analysis(orders)

cat("\n== Category summary ==\n"); print(results$categories, n = Inf)
cat("\n== Discount effect ==\n"); print(results$discount, n = Inf)
best <- results$monthly[which.max(results$monthly$revenue), ]
cat(sprintf("\nBest month: %s (PKR %s)\n", format(best$month, "%b %Y"), format(best$revenue, big.mark = ",")))
cat("Figures written to figures/\n")
