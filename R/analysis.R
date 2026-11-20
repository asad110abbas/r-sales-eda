suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(lubridate)
  library(tidyr)
})

# ---- reusable, tested helpers ---------------------------------------------
monthly_revenue <- function(orders) {
  orders |>
    mutate(month = floor_date(order_date, "month")) |>
    group_by(month) |>
    summarise(revenue = sum(revenue), orders = n(), .groups = "drop") |>
    arrange(month) |>
    mutate(mom_growth = revenue / lag(revenue) - 1)
}

category_summary <- function(orders) {
  orders |>
    group_by(category) |>
    summarise(aov = mean(revenue), orders = n(), revenue = sum(revenue),
              avg_rating = mean(rating), .groups = "drop") |>
    mutate(share = revenue / sum(revenue)) |>
    arrange(desc(revenue))
}

discount_effect <- function(orders) {
  orders |>
    group_by(discount) |>
    summarise(orders = n(), avg_qty = mean(quantity), avg_rating = mean(rating),
              revenue = sum(revenue), .groups = "drop")
}

weekday_heatmap_data <- function(orders) {
  orders |>
    mutate(weekday = wday(order_date, label = TRUE, week_start = 1),
           month = month(order_date, label = TRUE)) |>
    count(month, weekday, wt = revenue, name = "revenue")
}

# ---- report ---------------------------------------------------------------
run_analysis <- function(orders, fig_dir = "figures") {
  dir.create(fig_dir, showWarnings = FALSE)
  theme_set(theme_minimal(base_size = 12))
  pal <- c("#1F6FEB", "#00B39F", "#F2994A", "#9B51E0", "#EB5757")

  m <- monthly_revenue(orders)
  ggsave(file.path(fig_dir, "01_monthly_revenue.png"), width = 9, height = 4.5, dpi = 120,
         ggplot(m, aes(month, revenue / 1e6)) +
           geom_area(fill = pal[1], alpha = .15) + geom_line(colour = pal[1], linewidth = 1) +
           geom_smooth(method = "loess", formula = y ~ x, se = FALSE, colour = pal[3], linetype = "dashed") +
           labs(title = "Monthly revenue with trend", x = NULL, y = "Revenue (PKR millions)"))

  c <- category_summary(orders)
  ggsave(file.path(fig_dir, "02_category_share.png"), width = 8, height = 4.5, dpi = 120,
         ggplot(c, aes(reorder(category, revenue), revenue / 1e6, fill = category)) +
           geom_col(show.legend = FALSE) + coord_flip() + scale_fill_manual(values = pal) +
           geom_text(aes(label = scales::percent(share, accuracy = 1)), hjust = -0.1) +
           labs(title = "Revenue by category", x = NULL, y = "Revenue (PKR millions)"))

  ggsave(file.path(fig_dir, "03_price_distribution.png"), width = 9, height = 4.5, dpi = 120,
         ggplot(orders, aes(unit_price, fill = category)) +
           geom_density(alpha = .5, colour = NA) + scale_x_log10(labels = scales::comma) +
           scale_fill_manual(values = pal) +
           labs(title = "Unit price distribution (log scale)", x = "Unit price (PKR)", y = "Density"))

  ggsave(file.path(fig_dir, "04_weekday_heatmap.png"), width = 9, height = 4, dpi = 120,
         ggplot(weekday_heatmap_data(orders), aes(month, weekday, fill = revenue / 1e6)) +
           geom_tile(colour = "white") + scale_fill_gradient(low = "#EAF2FF", high = pal[1]) +
           labs(title = "Revenue heatmap: month x weekday", x = NULL, y = NULL, fill = "PKR M"))

  d <- discount_effect(orders)
  ggsave(file.path(fig_dir, "05_discount_vs_rating.png"), width = 7, height = 4.5, dpi = 120,
         ggplot(orders, aes(factor(discount), rating)) + geom_boxplot(fill = pal[2], alpha = .4) +
           labs(title = "Customer rating by discount level", x = "Discount", y = "Rating (1-5)"))

  list(monthly = m, categories = c, discount = d)
}
