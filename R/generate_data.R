# Synthetic e-commerce orders for exploratory analysis
generate_orders <- function(n = 6000, seed = 2025) {
  set.seed(seed)
  categories <- c("Mobiles", "Laptops", "Audio", "Wearables", "Accessories")
  base_price <- c(Mobiles = 55000, Laptops = 160000, Audio = 8000, Wearables = 20000, Accessories = 2000)
  dates <- sample(seq(as.Date("2024-01-01"), as.Date("2025-12-31"), by = "day"), n, replace = TRUE)
  category <- sample(categories, n, replace = TRUE, prob = c(.3, .12, .2, .13, .25))
  price <- round(base_price[category] * rlnorm(n, 0, 0.25))
  qty <- ifelse(category == "Accessories", rpois(n, 1.5) + 1, rpois(n, 0.2) + 1)
  discount <- sample(c(0, 0, 0, .05, .1, .2), n, replace = TRUE)
  data.frame(
    order_id = sprintf("O%06d", seq_len(n)),
    order_date = dates,
    city = sample(c("Karachi", "Lahore", "Islamabad", "Faisalabad", "Multan"), n, replace = TRUE,
                  prob = c(.32, .28, .18, .12, .10)),
    channel = sample(c("Online", "Store"), n, replace = TRUE, prob = c(.55, .45)),
    category = category,
    unit_price = unname(price),
    quantity = qty,
    discount = discount,
    rating = pmin(5, pmax(1, round(rnorm(n, 4.1 - 2 * discount, 0.8)))),
    stringsAsFactors = FALSE
  ) |>
    transform(revenue = round(unit_price * quantity * (1 - discount)))
}
